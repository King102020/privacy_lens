import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../features/access/presentation/access_cubit.dart';
import '../features/audit/presentation/audit_cubit.dart';
import '../features/settings/presentation/settings_cubit.dart';
import '../features/trackers/presentation/tracker_shield_cubit.dart';
import '../l10n/gen/app_localizations.dart';

class PrivacyLensApp extends StatefulWidget {
  const PrivacyLensApp({required this.router, super.key});

  final GoRouter router;

  @override
  State<PrivacyLensApp> createState() => _PrivacyLensAppState();
}

class _PrivacyLensAppState extends State<PrivacyLensApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _onResume);
    WidgetsBinding.instance.addPostFrameCallback((_) => _warmUp());
  }

  void _warmUp() {
    unawaited(context.read<AccessCubit>().refresh());
    unawaited(context.read<AuditCubit>().loadLatest());
    unawaited(context.read<TrackerShieldCubit>().refresh());
  }

  void _onResume() {
    unawaited(context.read<AccessCubit>().refresh());
    unawaited(context.read<TrackerShieldCubit>().refresh());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsCubit>().state.themeMode;
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: widget.router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
