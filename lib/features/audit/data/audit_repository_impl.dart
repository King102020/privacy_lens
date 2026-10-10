import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/platform/device_api.g.dart';
import '../../../core/platform/device_data_source.dart';
import '../../../core/preferences/app_preferences.dart';
import '../../../core/utils/dates.dart';
import '../domain/audit_repository.dart';
import '../domain/entities/audit_report.dart';
import '../domain/entities/tracker_sdk.dart';
import '../domain/risk_engine.dart';
import 'audit_local_data_source.dart';
import 'tracker_rule_pack_loader.dart';

class AuditRepositoryImpl implements AuditRepository {
  AuditRepositoryImpl({
    required DeviceDataSource device,
    required AuditLocalDataSource local,
    required TrackerRulePackLoader rulePackLoader,
    required AppPreferences preferences,
    required AppLogger logger,
    RiskEngine riskEngine = const RiskEngine(),
    DateTime Function() clock = DateTime.now,
  }) : _device = device,
       _local = local,
       _rulePackLoader = rulePackLoader,
       _preferences = preferences,
       _logger = logger,
       _riskEngine = riskEngine,
       _clock = clock;

  /// Last-used history is read over this window; Android aggregates months.
  static const Duration usageHistoryWindow = Duration(days: 120);

  final DeviceDataSource _device;
  final AuditLocalDataSource _local;
  final TrackerRulePackLoader _rulePackLoader;
  final AppPreferences _preferences;
  final AppLogger _logger;
  final RiskEngine _riskEngine;
  final DateTime Function() _clock;

  Future<Result<AuditReport>>? _inFlight;

  @override
  Future<Result<AuditReport?>> loadLatestReport() async {
    try {
      final scan = await _local.latestCompletedScan();
      if (scan == null) return const Ok(null);
      final rulePack = await _rulePackLoader.load();
      final snapshots = await _local.loadSnapshots(
        scan: scan,
        rulePack: rulePack,
      );
      return Ok(
        _riskEngine.evaluate(
          apps: snapshots,
          completedAt: scan.completedAt ?? scan.startedAt,
          hadUsageAccess: scan.hadUsageAccess,
          now: _clock(),
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.error(
        'Loading the latest report failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Err(StorageFailure());
    }
  }

  @override
  Future<Result<AuditReport>> runScan({
    void Function(ScanProgress progress)? onProgress,
  }) {
    final existing = _inFlight;
    if (existing != null) return existing;
    final scan = _scan(onProgress ?? (_) {}).whenComplete(() {
      _inFlight = null;
    });
    _inFlight = scan;
    return scan;
  }

  Future<Result<AuditReport>> _scan(
    void Function(ScanProgress progress) onProgress,
  ) async {
    final startedAt = _clock();
    onProgress(const ScanProgress(phase: ScanPhase.collecting));

    final accessResult = await _device.getAccessStatus();
    if (accessResult case Err(:final failure)) return Err(failure);
    var hasUsageAccess =
        (accessResult as Ok<AccessStatusDto>).value.hasUsageAccess;

    final appsResult = await _device.getInstalledApps(
      includeSystemApps: _preferences.includeSystemApps,
    );
    if (appsResult case Err(:final failure)) return Err(failure);
    final apps = (appsResult as Ok<List<InstalledAppDto>>).value;

    final specialResult = await _device.getSpecialAccess();
    if (specialResult case Err(:final failure)) return Err(failure);
    final specialAccess = (specialResult as Ok<List<SpecialAccessDto>>).value;

    var foreground = const <String, int>{};
    var lastUsed = const <String, DateTime>{};
    if (hasUsageAccess) {
      final usage = await _collectUsage(startedAt);
      if (usage == null) {
        hasUsageAccess = false;
      } else {
        (foreground, lastUsed) = usage;
      }
    }

    final rulePack = await _rulePackLoader.load();
    final (trackerMatches, trackerScanKeys) = await _scanTrackers(
      apps,
      rulePack,
      onProgress,
    );

    onProgress(const ScanProgress(phase: ScanPhase.analyzing));
    try {
      final scan = await _local.saveScan(
        CollectedScan(
          startedAt: startedAt,
          completedAt: _clock(),
          hadUsageAccess: hasUsageAccess,
          apps: apps,
          specialAccess: specialAccess,
          foregroundMsByPackage: foreground,
          lastUsedByPackage: lastUsed,
          trackerMatches: trackerMatches,
          trackerScanKeys: trackerScanKeys,
        ),
      );
      final snapshots = await _local.loadSnapshots(
        scan: scan,
        rulePack: rulePack,
      );
      final report = _riskEngine.evaluate(
        apps: snapshots,
        completedAt: scan.completedAt ?? startedAt,
        hadUsageAccess: hasUsageAccess,
        now: _clock(),
      );
      await _local.recordFindings(scan.id, report.findings);
      return Ok(report);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'Saving the scan failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Err(StorageFailure());
    }
  }

  /// Returns null when Usage Access was revoked between checks.
  Future<(Map<String, int>, Map<String, DateTime>)?> _collectUsage(
    DateTime now,
  ) async {
    final todayResult = await _device.getUsageStats(
      since: startOfLocalDay(now),
      until: now,
    );
    final historyResult = await _device.getUsageStats(
      since: now.subtract(usageHistoryWindow),
      until: now,
    );
    if (todayResult is! Ok<List<UsageStatDto>> ||
        historyResult is! Ok<List<UsageStatDto>>) {
      return null;
    }
    return (
      {
        for (final stat in todayResult.value)
          stat.packageName: stat.foregroundMs,
      },
      {
        for (final stat in historyResult.value)
          if (stat.lastUsedMs > 0)
            stat.packageName: DateTime.fromMillisecondsSinceEpoch(
              stat.lastUsedMs,
            ),
      },
    );
  }

  /// Scans only packages that changed since their last scan, or whose rule
  /// pack version changed. A failed scan keeps the previous results.
  Future<(Map<String, List<String>>, Map<String, String>)> _scanTrackers(
    List<InstalledAppDto> apps,
    TrackerRulePack rulePack,
    void Function(ScanProgress progress) onProgress,
  ) async {
    final storedKeys = await _local.trackerScanKeys();
    final keys = {
      for (final app in apps)
        app.packageName:
            '${app.versionCode}:${app.lastUpdateTimeMs}:${rulePack.version}',
    };
    final toScan = [
      for (final entry in keys.entries)
        if (storedKeys[entry.key] != entry.value) entry.key,
    ];
    if (toScan.isEmpty) {
      return (const <String, List<String>>{}, const <String, String>{});
    }

    onProgress(
      ScanProgress(phase: ScanPhase.scanningPackages, total: toScan.length),
    );
    final result = await _device.scanTrackerSdks(
      packageNames: toScan,
      signatures: [
        for (final sdk in rulePack.sdks)
          TrackerSignatureDto(
            trackerId: sdk.id,
            classPrefixes: sdk.classPrefixes,
          ),
      ],
      onProgress: (scanned, total) => onProgress(
        ScanProgress(
          phase: ScanPhase.scanningPackages,
          scanned: scanned,
          total: total,
        ),
      ),
    );

    return switch (result) {
      Ok(:final value) => (
        {for (final match in value) match.packageName: match.trackerIds},
        {
          for (final match in value)
            match.packageName: keys[match.packageName]!,
        },
      ),
      Err() => (const <String, List<String>>{}, const <String, String>{}),
    };
  }
}
