import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:privacy_lens/core/database/app_database.dart';
import 'package:privacy_lens/core/database/database_key_store.dart';
import 'package:privacy_lens/core/errors/result.dart';
import 'package:privacy_lens/core/platform/device_data_source.dart';
import 'package:privacy_lens/features/audit/domain/audit_repository.dart';
import 'package:privacy_lens/features/settings/data/data_vault_repository_impl.dart';
import 'package:privacy_lens/features/settings/domain/data_vault_repository.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/memory_database.dart';

class MockDevice extends Mock implements DeviceDataSource {}

class MockAudit extends Mock implements AuditRepository {}

class MockKeys extends Mock implements DatabaseKeyStore {}

void main() {
  test(
    'purge keeps the latest scan and drops old usage and dns rows',
    () async {
      final db = memoryDatabase();
      final now = DateTime.utc(2026, 10, 10);
      await db
          .into(db.scans)
          .insert(
            ScansCompanion.insert(
              startedAt: now.subtract(const Duration(days: 40)),
              appCount: const Value(1),
              findingCount: const Value(0),
              hadUsageAccess: false,
            ),
          );
      final latestId = await db
          .into(db.scans)
          .insert(
            ScansCompanion.insert(
              startedAt: now.subtract(const Duration(days: 1)),
              appCount: const Value(1),
              findingCount: const Value(0),
              hadUsageAccess: true,
            ),
          );
      await db
          .into(db.apps)
          .insert(
            AppsCompanion.insert(
              packageName: 'com.old',
              label: 'Old',
              versionCode: 1,
              isSystemApp: false,
              installedAt: now.subtract(const Duration(days: 200)),
              updatedAt: now.subtract(const Duration(days: 40)),
              requestsInternet: false,
            ),
          );
      await db
          .into(db.usageDaily)
          .insert(
            UsageDailyCompanion.insert(
              packageName: 'com.old',
              day: now.subtract(const Duration(days: 40)),
              foregroundMs: 10,
            ),
          );
      await db
          .into(db.dnsEvents)
          .insert(
            DnsEventsCompanion.insert(
              id: const Value(1),
              occurredAt: now.subtract(const Duration(days: 10)),
              domain: 'ads.example.com',
            ),
          );

      final vault = DataVaultRepositoryImpl(
        database: db,
        databaseFile: () async => File('missing.db'),
        keyStore: MockKeys(),
        device: MockDevice(),
        auditRepository: MockAudit(),
        logger: const SilentLogger(),
        clock: () => now,
      );

      final result = await vault.purgeExpired(
        retentionDays: 30,
        dnsRetentionDays: 7,
      );
      expect(result, isA<Ok<void>>());
      expect(await db.select(db.scans).get(), hasLength(1));
      expect((await db.select(db.scans).get()).single.id, latestId);
      expect(await db.select(db.usageDaily).get(), isEmpty);
      expect(await db.select(db.dnsEvents).get(), isEmpty);
    },
  );

  test('info reports a missing file as empty', () async {
    final vault = DataVaultRepositoryImpl(
      database: memoryDatabase(),
      databaseFile: () async => File('definitely-missing-privacy-lens.db'),
      keyStore: MockKeys(),
      device: MockDevice(),
      auditRepository: MockAudit(),
      logger: const SilentLogger(),
    );
    final result = await vault.info();
    expect((result as Ok<VaultInfo>).value.sizeBytes, 0);
  });
}
