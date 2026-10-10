import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/platform/device_api.g.dart';
import '../../../core/utils/dates.dart';
import '../domain/entities/app_snapshot.dart';
import '../domain/entities/capability.dart';
import '../domain/entities/finding.dart';
import '../domain/entities/special_access_kind.dart';
import '../domain/entities/tracker_sdk.dart';
import 'evidence_codec.dart';

const String _internetPermission = 'android.permission.INTERNET';

/// Facts gathered from the device during one scan, ready to persist.
class CollectedScan {
  const CollectedScan({
    required this.startedAt,
    required this.completedAt,
    required this.hadUsageAccess,
    required this.apps,
    required this.specialAccess,
    required this.foregroundMsByPackage,
    required this.lastUsedByPackage,
    required this.trackerMatches,
    required this.trackerScanKeys,
  });

  final DateTime startedAt;
  final DateTime completedAt;
  final bool hadUsageAccess;
  final List<InstalledAppDto> apps;
  final List<SpecialAccessDto> specialAccess;
  final Map<String, int> foregroundMsByPackage;
  final Map<String, DateTime> lastUsedByPackage;

  /// Tracker ids for packages scanned in this run only.
  final Map<String, List<String>> trackerMatches;

  /// New scan keys for packages scanned in this run only.
  final Map<String, String> trackerScanKeys;
}

class AuditLocalDataSource {
  AuditLocalDataSource(this._db);

  final AppDatabase _db;

  Future<Map<String, String?>> trackerScanKeys() async {
    final rows = await _db.select(_db.apps).get();
    return {for (final row in rows) row.packageName: row.trackerScanKey};
  }

  Future<Scan?> latestCompletedScan() =>
      (_db.select(_db.scans)
            ..where((scan) => scan.completedAt.isNotNull())
            ..orderBy([(scan) => OrderingTerm.desc(scan.completedAt)])
            ..limit(1))
          .getSingleOrNull();

  /// Replaces the current device snapshot and records the scan. Returns the
  /// new scan.
  Future<Scan> saveScan(CollectedScan collected) => _db.transaction(() async {
    final scanId = await _db
        .into(_db.scans)
        .insert(
          ScansCompanion.insert(
            startedAt: collected.startedAt,
            completedAt: Value(collected.completedAt),
            appCount: Value(collected.apps.length),
            hadUsageAccess: collected.hadUsageAccess,
          ),
        );

    final installed = {for (final app in collected.apps) app.packageName};
    await (_db.delete(
      _db.apps,
    )..where((app) => app.packageName.isNotIn(installed))).go();

    final usageDay = startOfLocalDay(collected.startedAt);
    await _db.batch((batch) {
      for (final app in collected.apps) {
        batch.insert(
          _db.apps,
          _appCompanion(app, collected),
          onConflict: DoUpdate(
            (_) => _appCompanion(app, collected),
            target: [_db.apps.packageName],
          ),
        );
      }
      batch
        ..deleteAll(_db.appPermissions)
        ..insertAll(_db.appPermissions, [
          for (final app in collected.apps)
            for (final permission in app.requestedPermissions.toSet())
              AppPermissionsCompanion.insert(
                packageName: app.packageName,
                permission: permission,
                isGranted: app.grantedPermissions.contains(permission),
              ),
        ])
        ..deleteAll(_db.specialAccess)
        ..insertAll(_db.specialAccess, [
          for (final grant in collected.specialAccess)
            if (installed.contains(grant.packageName))
              SpecialAccessCompanion.insert(
                packageName: grant.packageName,
                kind: _specialAccessKind(grant.kind).name,
              ),
        ], mode: InsertMode.insertOrIgnore);

      for (final entry in collected.trackerMatches.entries) {
        batch
          ..deleteWhere(
            _db.trackerSdkMatches,
            (match) => match.packageName.equals(entry.key),
          )
          ..insertAll(_db.trackerSdkMatches, [
            for (final trackerId in entry.value)
              TrackerSdkMatchesCompanion.insert(
                packageName: entry.key,
                trackerId: trackerId,
              ),
          ]);
      }

      if (collected.hadUsageAccess) {
        batch
          ..deleteWhere(_db.usageDaily, (row) => row.day.equals(usageDay))
          ..insertAll(_db.usageDaily, [
            for (final entry in collected.foregroundMsByPackage.entries)
              if (installed.contains(entry.key) && entry.value > 0)
                UsageDailyCompanion.insert(
                  packageName: entry.key,
                  day: usageDay,
                  foregroundMs: entry.value,
                ),
          ]);
      }
    });

    return (_db.select(
      _db.scans,
    )..where((scan) => scan.id.equals(scanId))).getSingle();
  });

  Future<void> recordFindings(int scanId, List<Finding> findings) =>
      _db.transaction(() async {
        for (final finding in findings) {
          final findingId = await _db
              .into(_db.findings)
              .insert(
                FindingsCompanion.insert(
                  scanId: scanId,
                  packageName: finding.packageName,
                  type: finding.type.name,
                  severity: finding.severity.name,
                ),
              );
          await _db.batch((batch) {
            batch.insertAll(_db.findingEvidence, [
              for (final evidence in finding.evidence)
                () {
                  final (kind, value) = EvidenceCodec.encode(evidence);
                  return FindingEvidenceCompanion.insert(
                    findingId: findingId,
                    kind: kind,
                    value: value,
                  );
                }(),
            ]);
          });
        }
        await (_db.update(_db.scans)..where((scan) => scan.id.equals(scanId)))
            .write(ScansCompanion(findingCount: Value(findings.length)));
      });

  /// Rebuilds every app snapshot from stored facts.
  Future<List<AppSnapshot>> loadSnapshots({
    required Scan scan,
    required TrackerRulePack rulePack,
  }) async {
    final apps = await _db.select(_db.apps).get();
    final granted = await (_db.select(
      _db.appPermissions,
    )..where((row) => row.isGranted.equals(true))).get();
    final special = await _db.select(_db.specialAccess).get();
    final trackers = await _db.select(_db.trackerSdkMatches).get();
    final usageDay = startOfLocalDay(scan.startedAt);
    final usage = await (_db.select(
      _db.usageDaily,
    )..where((row) => row.day.equals(usageDay))).get();
    final blocked = await _blockedDomainCountsByPackage();

    final grantedByPackage = <String, List<String>>{};
    for (final row in granted) {
      (grantedByPackage[row.packageName] ??= []).add(row.permission);
    }
    final specialByPackage = <String, Set<SpecialAccessKind>>{};
    for (final row in special) {
      final kind = SpecialAccessKind.values.asNameMap()[row.kind];
      if (kind != null) (specialByPackage[row.packageName] ??= {}).add(kind);
    }
    final trackersByPackage = <String, List<TrackerSdk>>{};
    for (final row in trackers) {
      final sdk = rulePack.byId(row.trackerId);
      if (sdk != null) (trackersByPackage[row.packageName] ??= []).add(sdk);
    }
    final foregroundByPackage = {
      for (final row in usage) row.packageName: row.foregroundMs,
    };

    return [
      for (final app in apps)
        AppSnapshot(
          packageName: app.packageName,
          label: app.label,
          versionName: app.versionName,
          isSystemApp: app.isSystemApp,
          iconPath: app.iconPath,
          installedAt: app.installedAt,
          updatedAt: app.updatedAt,
          requestsInternet: app.requestsInternet,
          granted: Capability.fromGrantedPermissions(
            grantedByPackage[app.packageName] ?? const [],
          ),
          specialAccess: specialByPackage[app.packageName] ?? const {},
          trackers: trackersByPackage[app.packageName] ?? const [],
          usage: scan.hadUsageAccess
              ? AppUsage(
                  day: usageDay,
                  foreground: Duration(
                    milliseconds: foregroundByPackage[app.packageName] ?? 0,
                  ),
                  lastUsedAt: app.lastUsedAt,
                )
              : null,
          blockedDomains: blocked[app.packageName] ?? const [],
        ),
    ];
  }

  Future<Map<String, List<BlockedDomainCount>>>
  _blockedDomainCountsByPackage() async {
    final rows = await _db
        .customSelect(
          'SELECT package_name, domain, COUNT(*) AS hits FROM dns_events '
          'WHERE package_name IS NOT NULL '
          'GROUP BY package_name, domain ORDER BY hits DESC',
          readsFrom: {_db.dnsEvents},
        )
        .get();
    final result = <String, List<BlockedDomainCount>>{};
    for (final row in rows) {
      (result[row.read<String>('package_name')] ??= []).add(
        BlockedDomainCount(
          domain: row.read<String>('domain'),
          count: row.read<int>('hits'),
        ),
      );
    }
    return result;
  }

  AppsCompanion _appCompanion(InstalledAppDto app, CollectedScan collected) {
    final scanKey = collected.trackerScanKeys[app.packageName];
    return AppsCompanion(
      packageName: Value(app.packageName),
      label: Value(app.label),
      versionName: Value(app.versionName),
      versionCode: Value(app.versionCode),
      isSystemApp: Value(app.isSystemApp),
      installerPackage: Value(app.installerPackage),
      installedAt: Value(
        DateTime.fromMillisecondsSinceEpoch(app.firstInstallTimeMs),
      ),
      updatedAt: Value(
        DateTime.fromMillisecondsSinceEpoch(app.lastUpdateTimeMs),
      ),
      iconPath: Value(app.iconPath),
      requestsInternet: Value(
        app.requestedPermissions.contains(_internetPermission),
      ),
      lastUsedAt: collected.hadUsageAccess
          ? Value(collected.lastUsedByPackage[app.packageName])
          : const Value.absent(),
      trackerScanKey: scanKey == null ? const Value.absent() : Value(scanKey),
    );
  }

  static SpecialAccessKind _specialAccessKind(SpecialAccessKindDto dto) =>
      switch (dto) {
        SpecialAccessKindDto.accessibilityService =>
          SpecialAccessKind.accessibilityService,
        SpecialAccessKindDto.notificationListener =>
          SpecialAccessKind.notificationListener,
        SpecialAccessKindDto.deviceAdmin => SpecialAccessKind.deviceAdmin,
        SpecialAccessKindDto.overlay => SpecialAccessKind.overlay,
      };
}
