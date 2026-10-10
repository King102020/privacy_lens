import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_key_store.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/platform/device_data_source.dart';
import '../../audit/domain/audit_repository.dart';
import '../../audit/domain/entities/audit_report.dart';
import '../domain/data_vault_repository.dart';
import 'report_exporter.dart';

class DataVaultRepositoryImpl implements DataVaultRepository {
  DataVaultRepositoryImpl({
    required AppDatabase database,
    required Future<File> Function() databaseFile,
    required DatabaseKeyStore keyStore,
    required DeviceDataSource device,
    required AuditRepository auditRepository,
    required AppLogger logger,
    DateTime Function() clock = DateTime.now,
  }) : _db = database,
       _databaseFile = databaseFile,
       _keyStore = keyStore,
       _device = device,
       _auditRepository = auditRepository,
       _logger = logger,
       _clock = clock;

  final AppDatabase _db;
  final Future<File> Function() _databaseFile;
  final DatabaseKeyStore _keyStore;
  final DeviceDataSource _device;
  final AuditRepository _auditRepository;
  final AppLogger _logger;
  final DateTime Function() _clock;

  @override
  Future<Result<VaultInfo>> info() async {
    try {
      final file = await _databaseFile();
      final size = file.existsSync() ? await file.length() : 0;
      final cipher = await _db
          .customSelect('PRAGMA cipher_version')
          .getSingleOrNull();
      final version = cipher?.data.values.firstOrNull?.toString();
      return Ok(
        VaultInfo(
          sizeBytes: size,
          cipherVersion: version == null || version.isEmpty ? null : version,
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.warning(
        'Reading vault info failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Err(StorageFailure());
    }
  }

  @override
  Future<Result<void>> purgeExpired({
    required int retentionDays,
    required int dnsRetentionDays,
  }) async {
    final now = _clock();
    final cutoff = now.subtract(Duration(days: retentionDays));
    final dnsCutoff = now.subtract(Duration(days: dnsRetentionDays));
    try {
      await _db.transaction(() async {
        final latest =
            await (_db.select(_db.scans)
                  ..orderBy([(scan) => OrderingTerm.desc(scan.startedAt)])
                  ..limit(1))
                .getSingleOrNull();
        await (_db.delete(_db.scans)..where(
              (scan) =>
                  scan.startedAt.isSmallerThanValue(cutoff) &
                  scan.id.equals(latest?.id ?? -1).not(),
            ))
            .go();
        await (_db.delete(
          _db.usageDaily,
        )..where((row) => row.day.isSmallerThanValue(cutoff))).go();
        await (_db.delete(
          _db.dnsEvents,
        )..where((row) => row.occurredAt.isSmallerThanValue(dnsCutoff))).go();
      });
      return const Ok(null);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'Purging old data failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Err(StorageFailure());
    }
  }

  @override
  Future<Result<ExportOutcome>> exportLatestReport(ExportFormat format) async {
    final reportResult = await _auditRepository.loadLatestReport();
    if (reportResult case Err(:final failure)) return Err(failure);
    final report = (reportResult as Ok<AuditReport?>).value;
    if (report == null) return const Ok(ExportOutcome.empty);

    final stamp = report.completedAt.toLocal().toIso8601String().substring(
      0,
      10,
    );
    final (content, extension, mimeType) = switch (format) {
      ExportFormat.json => (
        ReportExporter.toJson(report),
        'json',
        'application/json',
      ),
      ExportFormat.csv => (ReportExporter.toCsv(report), 'csv', 'text/csv'),
    };
    final saved = await _device.saveDocument(
      suggestedName: 'privacy-lens-report-$stamp.$extension',
      mimeType: mimeType,
      bytes: Uint8List.fromList(utf8.encode(content)),
    );
    return switch (saved) {
      Ok(:final value) => Ok(
        value ? ExportOutcome.saved : ExportOutcome.canceled,
      ),
      Err(:final failure) => Err(failure),
    };
  }

  @override
  Future<Result<void>> wipeAll() async {
    try {
      final newKey = _keyStore.generate();
      await _db.wipeAndRekey(newKey);
      await _keyStore.save(newKey);
    } on Object catch (error, stackTrace) {
      _logger.error('Wiping data failed', error: error, stackTrace: stackTrace);
      return const Err(StorageFailure());
    }
    return _device.clearNativeData();
  }
}
