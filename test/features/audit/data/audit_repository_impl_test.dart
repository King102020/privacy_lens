import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:privacy_lens/core/errors/app_failure.dart';
import 'package:privacy_lens/core/errors/result.dart';
import 'package:privacy_lens/core/platform/device_api.g.dart';
import 'package:privacy_lens/core/platform/device_data_source.dart';
import 'package:privacy_lens/core/preferences/app_preferences.dart';
import 'package:privacy_lens/features/audit/data/audit_local_data_source.dart';
import 'package:privacy_lens/features/audit/data/audit_repository_impl.dart';
import 'package:privacy_lens/features/audit/data/tracker_rule_pack_loader.dart';
import 'package:privacy_lens/features/audit/domain/entities/audit_report.dart';
import 'package:privacy_lens/features/audit/domain/entities/severity.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/memory_database.dart';

class MockDevice extends Mock implements DeviceDataSource {}

class MockPreferences extends Mock implements AppPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDevice device;
  late MockPreferences preferences;
  late AuditRepositoryImpl repository;

  const pack = '''
{"version":"test","trackers":[{"id":"ads","name":"Ads","category":"advertising","classPrefixes":["com.ads"]}]}
''';

  setUpAll(() {
    registerFallbackValue(<String>[]);
    registerFallbackValue(<TrackerSignatureDto>[]);
  });

  setUp(() {
    device = MockDevice();
    preferences = MockPreferences();
    when(() => preferences.includeSystemApps).thenReturn(false);
    final database = memoryDatabase();
    repository = AuditRepositoryImpl(
      device: device,
      local: AuditLocalDataSource(database),
      rulePackLoader: TrackerRulePackLoader(bundle: _StringBundle(pack)),
      preferences: preferences,
      logger: const SilentLogger(),
      clock: () => DateTime.utc(2026, 10, 10, 12),
    );
  });

  test('scan persists apps and produces a report', () async {
    when(device.getAccessStatus).thenAnswer(
      (_) async => Ok(
        AccessStatusDto(
          hasUsageAccess: false,
          isRestrictedSettingsLikely: false,
          sdkInt: 34,
        ),
      ),
    );
    when(() => device.getInstalledApps(includeSystemApps: false)).thenAnswer(
      (_) async => Ok([
        InstalledAppDto(
          packageName: 'com.cam',
          label: 'Cam',
          versionCode: 2,
          isSystemApp: false,
          firstInstallTimeMs: DateTime.utc(2025).millisecondsSinceEpoch,
          lastUpdateTimeMs: DateTime.utc(2026).millisecondsSinceEpoch,
          requestedPermissions: const [
            'android.permission.CAMERA',
            'android.permission.RECORD_AUDIO',
            'android.permission.ACCESS_FINE_LOCATION',
          ],
          grantedPermissions: const [
            'android.permission.CAMERA',
            'android.permission.RECORD_AUDIO',
            'android.permission.ACCESS_FINE_LOCATION',
          ],
        ),
      ]),
    );
    when(device.getSpecialAccess).thenAnswer((_) async => const Ok([]));
    when(
      () => device.scanTrackerSdks(
        packageNames: any(named: 'packageNames'),
        signatures: any(named: 'signatures'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((_) async => const Ok([]));

    final first = repository.runScan();
    final second = repository.runScan();
    expect(identical(first, second), isTrue);

    final result = await first;
    final report = (result as Ok<AuditReport>).value;
    expect(report.apps, hasLength(1));
    expect(report.apps.single.riskLevel, RiskLevel.medium);
    expect(report.hadUsageAccess, isFalse);

    final latest = await repository.loadLatestReport();
    expect((latest as Ok<AuditReport?>).value?.apps.single.app.label, 'Cam');
  });

  test('maps a device failure', () async {
    when(
      device.getAccessStatus,
    ).thenAnswer((_) async => const Err(PlatformFailure('io')));
    final result = await repository.runScan();
    expect(result, isA<Err<AuditReport>>());
    expect((result as Err<AuditReport>).failure, isA<PlatformFailure>());
  });
}

class _StringBundle extends CachingAssetBundle {
  _StringBundle(this.source);

  final String source;

  @override
  Future<ByteData> load(String key) async {
    final encoded = Uint8List.fromList(source.codeUnits);
    return ByteData.view(encoded.buffer);
  }
}
