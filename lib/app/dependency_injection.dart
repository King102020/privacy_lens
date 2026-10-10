import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/database/app_database.dart';
import '../core/logging/app_logger.dart';
import '../core/platform/device_data_source.dart';
import '../core/preferences/app_preferences.dart';
import '../features/access/domain/device_access_repository.dart';
import '../features/access/presentation/access_cubit.dart';
import '../features/audit/domain/audit_repository.dart';
import '../features/audit/presentation/audit_cubit.dart';
import '../features/settings/domain/data_vault_repository.dart';
import '../features/settings/presentation/data_vault_cubit.dart';
import '../features/settings/presentation/settings_cubit.dart';
import '../features/trackers/domain/tracker_shield_repository.dart';
import '../features/trackers/presentation/tracker_shield_cubit.dart';

class AppDependencies {
  const AppDependencies({
    required this.preferences,
    required this.logger,
    required this.database,
    required this.device,
    required this.auditRepository,
    required this.accessRepository,
    required this.shieldRepository,
    required this.vaultRepository,
    required this.settingsCubit,
  });

  final AppPreferences preferences;
  final AppLogger logger;
  final AppDatabase database;
  final DeviceDataSource device;
  final AuditRepository auditRepository;
  final DeviceAccessRepository accessRepository;
  final TrackerShieldRepository shieldRepository;
  final DataVaultRepository vaultRepository;
  final SettingsCubit settingsCubit;
}

class AppScope extends StatelessWidget {
  const AppScope({required this.dependencies, required this.child, super.key});

  final AppDependencies dependencies;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppPreferences>.value(
          value: dependencies.preferences,
        ),
        RepositoryProvider<AppLogger>.value(value: dependencies.logger),
        RepositoryProvider<AppDatabase>.value(value: dependencies.database),
        RepositoryProvider<DeviceDataSource>.value(value: dependencies.device),
        RepositoryProvider<AuditRepository>.value(
          value: dependencies.auditRepository,
        ),
        RepositoryProvider<DeviceAccessRepository>.value(
          value: dependencies.accessRepository,
        ),
        RepositoryProvider<TrackerShieldRepository>.value(
          value: dependencies.shieldRepository,
        ),
        RepositoryProvider<DataVaultRepository>.value(
          value: dependencies.vaultRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>.value(value: dependencies.settingsCubit),
          BlocProvider(
            create: (_) => AccessCubit(dependencies.accessRepository),
          ),
          BlocProvider(create: (_) => AuditCubit(dependencies.auditRepository)),
          BlocProvider(
            create: (_) => TrackerShieldCubit(dependencies.shieldRepository),
          ),
          BlocProvider(
            create: (_) {
              final cubit = DataVaultCubit(dependencies.vaultRepository);
              unawaited(cubit.load());
              return cubit;
            },
          ),
        ],
        child: child,
      ),
    );
  }
}
