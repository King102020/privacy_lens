import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:privacy_lens/core/errors/result.dart';
import 'package:privacy_lens/core/preferences/app_preferences.dart';
import 'package:privacy_lens/core/theme/app_theme.dart';
import 'package:privacy_lens/features/access/domain/device_access_repository.dart';
import 'package:privacy_lens/features/access/presentation/access_cubit.dart';
import 'package:privacy_lens/features/audit/domain/audit_repository.dart';
import 'package:privacy_lens/features/audit/domain/risk_engine.dart';
import 'package:privacy_lens/features/audit/presentation/audit_cubit.dart';
import 'package:privacy_lens/features/home/presentation/home_screen.dart';
import 'package:privacy_lens/features/onboarding/presentation/onboarding_screen.dart';
import 'package:privacy_lens/features/settings/presentation/settings_cubit.dart';
import 'package:privacy_lens/features/trackers/domain/tracker_shield_entities.dart';
import 'package:privacy_lens/features/trackers/domain/tracker_shield_repository.dart';
import 'package:privacy_lens/features/trackers/presentation/tracker_shield_cubit.dart';
import 'package:privacy_lens/l10n/gen/app_localizations.dart';

import '../test/helpers/fixtures.dart';

class MockAudit extends Mock implements AuditRepository {}

class MockAccess extends Mock implements DeviceAccessRepository {}

class MockShield extends Mock implements TrackerShieldRepository {}

class MockPreferences extends Mock implements AppPreferences {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding finish then empty home then scan', (tester) async {
    final audit = MockAudit();
    final access = MockAccess();
    final shield = MockShield();
    final preferences = MockPreferences();
    when(() => preferences.onboardingCompleted).thenReturn(false);
    when(() => preferences.themeMode).thenReturn(ThemeMode.system);
    when(() => preferences.retentionDays).thenReturn(30);
    when(() => preferences.dnsRetentionDays).thenReturn(7);
    when(() => preferences.includeSystemApps).thenReturn(false);
    when(
      () => preferences.setOnboardingCompleted(any()),
    ).thenAnswer((_) async {});
    when(access.getStatus).thenAnswer(
      (_) async => const Ok(
        AccessStatus(hasUsageAccess: false, isRestrictedSettingsLikely: false),
      ),
    );
    when(shield.getStatus).thenAnswer(
      (_) async => const Ok(
        TrackerShieldStatus(
          isRunning: false,
          blocklistVersion: 'test',
          blocklistSize: 1,
        ),
      ),
    );
    when(shield.importBlockedEvents).thenAnswer((_) async => const Ok(0));
    when(
      shield.loadActivity,
    ).thenAnswer((_) async => const Ok(ShieldActivity.empty));
    when(audit.loadLatestReport).thenAnswer((_) async => const Ok(null));
    final report = const RiskEngine().evaluate(
      apps: [snapshot(label: 'Cam')],
      completedAt: testNow,
      hadUsageAccess: false,
      now: testNow,
    );
    when(
      () => audit.runScan(onProgress: any(named: 'onProgress')),
    ).thenAnswer((_) async => Ok(report));

    final settings = SettingsCubit(preferences);
    Widget app(Widget home) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>.value(value: settings),
          BlocProvider(create: (_) => AccessCubit(access)),
          BlocProvider(create: (_) => AuditCubit(audit)),
          BlocProvider(create: (_) => TrackerShieldCubit(shield)),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: home,
        ),
      );
    }

    await tester.pumpWidget(app(const OnboardingScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip intro'));
    await tester.pumpAndSettle();
    expect(settings.state.onboardingCompleted, isTrue);

    final auditCubit = AuditCubit(audit);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>.value(value: settings),
          BlocProvider(create: (_) => AccessCubit(access)),
          BlocProvider<AuditCubit>.value(value: auditCubit),
          BlocProvider(create: (_) => TrackerShieldCubit(shield)),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        ),
      ),
    );
    await auditCubit.loadLatest();
    await tester.pumpAndSettle();
    expect(find.text('Run your first audit'), findsOneWidget);
    await tester.tap(find.text('Run full audit'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Cam'), findsWidgets);
  });
}
