import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:privacy_lens/core/errors/result.dart';
import 'package:privacy_lens/core/preferences/app_preferences.dart';
import 'package:privacy_lens/core/theme/app_theme.dart';
import 'package:privacy_lens/features/access/domain/device_access_repository.dart';
import 'package:privacy_lens/features/access/presentation/access_cubit.dart';
import 'package:privacy_lens/features/onboarding/presentation/onboarding_screen.dart';
import 'package:privacy_lens/features/settings/presentation/settings_cubit.dart';
import 'package:privacy_lens/features/trackers/domain/tracker_shield_repository.dart';
import 'package:privacy_lens/features/trackers/presentation/tracker_shield_cubit.dart';
import 'package:privacy_lens/l10n/gen/app_localizations.dart';
import 'package:rive/rive.dart' show RiveWidget;

class MockPreferences extends Mock implements AppPreferences {}

class MockAccess extends Mock implements DeviceAccessRepository {}

class MockShield extends Mock implements TrackerShieldRepository {}

void main() {
  late MockPreferences preferences;
  late MockAccess access;
  late MockShield shield;

  setUp(() {
    preferences = MockPreferences();
    access = MockAccess();
    shield = MockShield();
    when(() => preferences.onboardingCompleted).thenReturn(false);
    when(() => preferences.themeMode).thenReturn(ThemeMode.system);
    when(() => preferences.retentionDays).thenReturn(30);
    when(() => preferences.dnsRetentionDays).thenReturn(7);
    when(() => preferences.includeSystemApps).thenReturn(false);
    when(() => preferences.seenTabGuides).thenReturn(const []);
    when(
      () => preferences.setOnboardingCompleted(any()),
    ).thenAnswer((_) async {});
    when(
      () => access.openUsageAccessSettings(),
    ).thenAnswer((_) async => const Ok(true));
    when(() => shield.start()).thenAnswer((_) async => const Ok(false));
  });

  testWidgets('actions follow the motion and skip finishes', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      final settings = SettingsCubit(preferences);
      final accessCubit = AccessCubit(access);
      final shieldCubit = TrackerShieldCubit(shield);
      addTearDown(settings.close);
      addTearDown(accessCubit.close);
      addTearDown(shieldCubit.close);

      Future<void> pump(int beat) => tester.pumpWidget(
        _app(
          settings: settings,
          access: accessCubit,
          shield: shieldCubit,
          beat: beat,
        ),
      );

      await pump(0);
      expect(
        find.bySemanticsLabel('Your apps hide ad and tracking code'),
        findsOneWidget,
      );
      expect(find.byType(RiveWidget), findsNothing);
      expect(find.text('Open Usage Access').hitTestable(), findsNothing);
      expect(find.text('Turn on Tracker Shield').hitTestable(), findsNothing);

      await pump(1);
      expect(
        find.bySemanticsLabel('It sends your activity to ad companies'),
        findsOneWidget,
      );
      expect(find.text('Open Usage Access').hitTestable(), findsNothing);

      await pump(2);
      expect(
        find.bySemanticsLabel('They build a profile to target you'),
        findsOneWidget,
      );
      expect(find.textContaining('restricted settings'), findsNothing);
      expect(find.text('Turn on Tracker Shield').hitTestable(), findsNothing);

      await pump(3);
      expect(
        find.bySemanticsLabel('See it, block it, take back permissions'),
        findsOneWidget,
      );
      await tester.tap(find.text('Open Usage Access'));
      await tester.pump();
      verify(() => access.openUsageAccessSettings()).called(1);
      await tester.tap(find.text('Turn on Tracker Shield'));
      await tester.pump();
      verify(() => shield.start()).called(1);

      await tester.tap(find.text('Skip intro'));
      await tester.pump();
      verify(() => preferences.setOnboardingCompleted(true)).called(1);
    } finally {
      semantics.dispose();
    }
  });
}

Widget _app({
  required SettingsCubit settings,
  required AccessCubit access,
  required TrackerShieldCubit shield,
  required int beat,
}) {
  return MaterialApp(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: settings),
        BlocProvider.value(value: access),
        BlocProvider.value(value: shield),
      ],
      child: OnboardingScreen(beat: beat),
    ),
  );
}
