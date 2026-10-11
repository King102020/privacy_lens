import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/platform/device_api.g.dart';
import '../../../core/platform/tracker_shield_data_source.dart';
import '../../../core/preferences/app_preferences.dart';
import '../../../core/utils/dates.dart';
import '../../audit/domain/entities/tracker_sdk.dart';
import '../domain/tracker_shield_entities.dart';
import '../domain/tracker_shield_repository.dart';
import 'tracker_domain_catalog.dart';

class TrackerShieldRepositoryImpl implements TrackerShieldRepository {
  TrackerShieldRepositoryImpl({
    required TrackerShieldDataSource dataSource,
    required AppDatabase database,
    required TrackerDomainCatalog catalog,
    required AppPreferences preferences,
    required AppLogger logger,
    DateTime Function() clock = DateTime.now,
  }) : _dataSource = dataSource,
       _db = database,
       _catalog = catalog,
       _preferences = preferences,
       _logger = logger,
       _clock = clock;

  static const int _importBatchSize = 500;
  static const int _hoursPerDay = 24;

  final TrackerShieldDataSource _dataSource;
  final AppDatabase _db;
  final TrackerDomainCatalog _catalog;
  final AppPreferences _preferences;
  final AppLogger _logger;
  final DateTime Function() _clock;

  Future<Result<int>>? _importInFlight;

  @override
  Future<Result<TrackerShieldStatus>> getStatus() async {
    final result = await _dataSource.getStatus();
    return switch (result) {
      Ok(:final value) => Ok(
        TrackerShieldStatus(
          isRunning: value.isRunning,
          blocklistVersion: value.blocklistVersion,
          blocklistSize: value.blocklistSize,
        ),
      ),
      Err(:final failure) => Err(failure),
    };
  }

  @override
  Future<Result<bool>> start() async {
    final started = await _dataSource.start();
    if (started case Ok(value: true)) {
      final applied = await applyPolicy();
      if (applied is Err) return Err(applied.failure);
    }
    return started;
  }

  @override
  Future<Result<void>> stop() => _dataSource.stop();

  @override
  Future<Result<int>> importBlockedEvents() {
    final existing = _importInFlight;
    if (existing != null) return existing;
    final import = _import().whenComplete(() {
      _importInFlight = null;
    });
    _importInFlight = import;
    return import;
  }

  Future<Result<int>> _import() async {
    var imported = 0;
    while (true) {
      final batch = await _dataSource.fetchBlockedEvents(
        afterId: 0,
        limit: _importBatchSize,
      );
      if (batch case Err(:final failure)) return Err(failure);
      final events = (batch as Ok<List<DnsEventDto>>).value;
      if (events.isEmpty) return Ok(imported);

      try {
        await _db.batch((writer) {
          writer.insertAll(_db.dnsEvents, [
            for (final event in events)
              DnsEventsCompanion.insert(
                id: Value(event.id),
                occurredAt: DateTime.fromMillisecondsSinceEpoch(
                  event.timestampMs,
                ),
                domain: event.domain,
                packageName: Value(event.packageName),
              ),
          ], mode: InsertMode.insertOrIgnore);
        });
      } on Object catch (error, stackTrace) {
        _logger.error(
          'Importing blocked lookups failed',
          error: error,
          stackTrace: stackTrace,
        );
        return const Err(StorageFailure());
      }

      final deleted = await _dataSource.deleteBlockedEventsUpTo(events.last.id);
      if (deleted case Err(:final failure)) return Err(failure);
      imported += events.length;
    }
  }

  @override
  Future<Result<ShieldActivity>> loadActivity() async {
    try {
      final summaryRows = await _db
          .customSelect(
            'SELECT domain, package_name, COUNT(*) AS hits, '
            'MAX(occurred_at) AS last_at FROM dns_events '
            'GROUP BY domain, package_name ORDER BY hits DESC',
            readsFrom: {_db.dnsEvents},
          )
          .get();
      if (summaryRows.isEmpty) return const Ok(ShieldActivity.empty);

      final summaries = [
        for (final row in summaryRows)
          BlockedDomainSummary(
            domain: row.read<String>('domain'),
            category: _catalog.categoryFor(row.read<String>('domain')),
            packageName: row.readNullable<String>('package_name'),
            count: row.read<int>('hits'),
            lastBlockedAt: DateTime.fromMillisecondsSinceEpoch(
              row.read<int>('last_at') * 1000,
            ),
          ),
      ];

      final today =
          await (_db.selectOnly(_db.dnsEvents)
                ..addColumns([_db.dnsEvents.occurredAt])
                ..where(
                  _db.dnsEvents.occurredAt.isBiggerOrEqualValue(
                    startOfLocalDay(_clock()),
                  ),
                ))
              .map((row) => row.read(_db.dnsEvents.occurredAt)!)
              .get();
      final byHour = List<int>.filled(_hoursPerDay, 0);
      for (final moment in today) {
        byHour[moment.toLocal().hour]++;
      }

      return Ok(
        ShieldActivity(
          summaries: summaries,
          blockedTodayByHour: today.isEmpty ? const [] : byHour,
          totalBlocked: summaries.fold(0, (sum, item) => sum + item.count),
          distinctDomains: summaries.map((item) => item.domain).toSet().length,
          distinctApps: summaries
              .map((item) => item.packageName)
              .whereType<String>()
              .toSet()
              .length,
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.error(
        'Loading shield activity failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Err(StorageFailure());
    }
  }

  @override
  ShieldPolicy currentPolicy() {
    final enabled = <TrackerCategory>{
      for (final name in _preferences.enabledShieldCategories)
        if (TrackerCategory.values.asNameMap()[name] case final category?
            when TrackerDomainCatalog.shieldCategories.contains(category))
          category,
    };
    return ShieldPolicy(
      enabledCategories: enabled,
      extraBlocked: _preferences.customBlockedDomains,
      allowed: _preferences.customAllowedDomains,
      countsByCategory: _catalog.countsByCategory,
    );
  }

  @override
  Future<Result<void>> applyPolicy() {
    final policy = currentPolicy();
    return _dataSource.applyPolicy(
      enabledCategories: [
        for (final category in policy.enabledCategories) category.name,
      ],
      extraBlocked: policy.extraBlocked,
      allowed: policy.allowed,
    );
  }

  @override
  Future<Result<void>> setCategoryEnabled(
    TrackerCategory category,
    bool enabled,
  ) async {
    final next = currentPolicy().enabledCategories.toSet();
    if (enabled) {
      next.add(category);
    } else {
      next.remove(category);
    }
    await _preferences.setEnabledShieldCategories([
      for (final item in next) item.name,
    ]);
    return applyPolicy();
  }

  @override
  Future<Result<bool>> addCustomDomain(
    String raw, {
    required bool allow,
  }) async {
    final host = AppPreferences.tryParseHostname(raw);
    if (host == null) return const Ok(false);
    await _writeCustomDomain(host, allow: allow);
    final applied = await applyPolicy();
    return switch (applied) {
      Ok() => const Ok(true),
      Err(:final failure) => Err(failure),
    };
  }

  @override
  Future<Result<void>> removeCustomDomain(String domain) async {
    final host = domain.toLowerCase();
    await _preferences.setCustomBlockedDomains([
      for (final item in _preferences.customBlockedDomains)
        if (item != host) item,
    ]);
    await _preferences.setCustomAllowedDomains([
      for (final item in _preferences.customAllowedDomains)
        if (item != host) item,
    ]);
    return applyPolicy();
  }

  @override
  Future<Result<void>> allowDomain(String domain) async {
    final host = AppPreferences.tryParseHostname(domain);
    if (host == null) return const Ok(null);
    await _writeCustomDomain(host, allow: true);
    return applyPolicy();
  }

  Future<void> _writeCustomDomain(String host, {required bool allow}) async {
    final blocked = _preferences.customBlockedDomains.toSet();
    final allowed = _preferences.customAllowedDomains.toSet();
    if (allow) {
      allowed.add(host);
      blocked.remove(host);
    } else {
      blocked.add(host);
      allowed.remove(host);
    }
    await _preferences.setCustomBlockedDomains(blocked);
    await _preferences.setCustomAllowedDomains(allowed);
  }
}
