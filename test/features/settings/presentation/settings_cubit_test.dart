import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:privacy_lens/core/preferences/app_preferences.dart';
import 'package:privacy_lens/features/settings/presentation/settings_cubit.dart';

class MockPreferences extends Mock implements AppPreferences {}

void main() {
  late MockPreferences preferences;

  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  setUp(() {
    preferences = MockPreferences();
    when(() => preferences.onboardingCompleted).thenReturn(false);
    when(() => preferences.themeMode).thenReturn(ThemeMode.system);
    when(() => preferences.retentionDays).thenReturn(30);
    when(() => preferences.dnsRetentionDays).thenReturn(7);
    when(() => preferences.includeSystemApps).thenReturn(false);
    when(() => preferences.seenTabGuides).thenReturn(const []);
    when(() => preferences.markTabGuideSeen(any())).thenAnswer((_) async {});
    when(() => preferences.clearSeenTabGuides()).thenAnswer((_) async {});
    when(
      () => preferences.setOnboardingCompleted(any()),
    ).thenAnswer((_) async {});
    when(() => preferences.setThemeMode(any())).thenAnswer((_) async {});
  });

  blocTest<SettingsCubit, SettingsState>(
    'completeOnboarding persists and emits',
    build: () => SettingsCubit(preferences),
    act: (cubit) => cubit.completeOnboarding(),
    expect: () => [
      isA<SettingsState>().having(
        (state) => state.onboardingCompleted,
        'done',
        true,
      ),
    ],
    verify: (_) {
      verify(() => preferences.setOnboardingCompleted(true)).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'replay tips clears seen tabs',
    build: () => SettingsCubit(preferences),
    seed: () =>
        SettingsState.from(preferences).copyWith(seenTabGuides: const ['home']),
    act: (cubit) => cubit.replayTabGuides(),
    expect: () => [
      isA<SettingsState>().having(
        (state) => state.seenTabGuides,
        'seen',
        isEmpty,
      ),
    ],
    verify: (_) {
      verify(() => preferences.clearSeenTabGuides()).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'setThemeMode persists',
    build: () => SettingsCubit(preferences),
    act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
    expect: () => [
      isA<SettingsState>().having(
        (state) => state.themeMode,
        'theme',
        ThemeMode.dark,
      ),
    ],
  );
}
