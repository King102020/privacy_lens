import 'package:flutter/widgets.dart';

import '../core/database/database_key_store.dart';
import '../core/database/database_opener.dart';
import '../core/logging/app_logger.dart';
import '../core/platform/device_data_source.dart';
import '../core/platform/tracker_shield_data_source.dart';
import '../core/preferences/app_preferences.dart';
import '../features/access/data/device_access_repository_impl.dart';
import '../features/audit/data/audit_local_data_source.dart';
import '../features/audit/data/audit_repository_impl.dart';
import '../features/audit/data/tracker_rule_pack_loader.dart';
import '../features/settings/data/data_vault_repository_impl.dart';
import '../features/settings/presentation/settings_cubit.dart';
import '../features/trackers/data/tracker_domain_catalog.dart';
import '../features/trackers/data/tracker_shield_repository_impl.dart';
import 'app.dart';
import 'dependency_injection.dart';
import 'router.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  const logger = ConsoleAppLogger();
  final preferences = await AppPreferences.create();
  final keyStore = DatabaseKeyStore();
  final database = await openAppDatabase(keyStore: keyStore, logger: logger);
  final device = DeviceDataSource(logger: logger);
  final shield = TrackerShieldDataSource(logger: logger);
  final catalog = await TrackerDomainCatalog.load();

  final auditRepository = AuditRepositoryImpl(
    device: device,
    local: AuditLocalDataSource(database),
    rulePackLoader: TrackerRulePackLoader(),
    preferences: preferences,
    logger: logger,
  );
  final accessRepository = DeviceAccessRepositoryImpl(device);
  final shieldRepository = TrackerShieldRepositoryImpl(
    dataSource: shield,
    database: database,
    catalog: catalog,
    preferences: preferences,
    logger: logger,
  );
  final vaultRepository = DataVaultRepositoryImpl(
    database: database,
    databaseFile: databaseFile,
    keyStore: keyStore,
    device: device,
    auditRepository: auditRepository,
    logger: logger,
  );

  final purged = await vaultRepository.purgeExpired(
    retentionDays: preferences.retentionDays,
    dnsRetentionDays: preferences.dnsRetentionDays,
  );
  purged.fold((_) {}, (_) => logger.warning('Retention purge skipped'));

  final settingsCubit = SettingsCubit(preferences);
  runApp(
    AppScope(
      dependencies: AppDependencies(
        preferences: preferences,
        logger: logger,
        database: database,
        device: device,
        auditRepository: auditRepository,
        accessRepository: accessRepository,
        shieldRepository: shieldRepository,
        vaultRepository: vaultRepository,
        settingsCubit: settingsCubit,
      ),
      child: PrivacyLensApp(router: createRouter(settings: settingsCubit)),
    ),
  );
}
