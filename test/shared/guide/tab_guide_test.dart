import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:privacy_lens/core/preferences/app_preferences.dart';
import 'package:privacy_lens/core/theme/app_theme.dart';
import 'package:privacy_lens/features/settings/presentation/settings_cubit.dart';
import 'package:privacy_lens/l10n/gen/app_localizations.dart';
import 'package:privacy_lens/shared/guide/spotlight_tour.dart';
import 'package:privacy_lens/shared/guide/tab_guide.dart';

class MockPreferences extends Mock implements AppPreferences {}

void main() {
  late List<String> seen;
  late MockPreferences prefs;

  setUp(() {
    seen = [];
    prefs = MockPreferences();
    when(() => prefs.onboardingCompleted).thenReturn(true);
    when(() => prefs.themeMode).thenReturn(ThemeMode.system);
    when(() => prefs.retentionDays).thenReturn(30);
    when(() => prefs.dnsRetentionDays).thenReturn(7);
    when(() => prefs.includeSystemApps).thenReturn(false);
    when(() => prefs.seenTabGuides).thenAnswer((_) => List.of(seen));
    when(() => prefs.markTabGuideSeen(any())).thenAnswer((invocation) async {
      seen.add(invocation.positionalArguments.first as String);
    });
  });

  Future<SettingsCubit> pump(
    WidgetTester tester, {
    bool ready = true,
    bool visible = true,
  }) async {
    final cubit = SettingsCubit(prefs);
    addTearDown(cubit.close);
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: TickerMode(
            enabled: visible,
            child: TabTour(
              id: TabGuideIds.home,
              ready: ready,
              steps: (_) => [
                TourStep(target: key, title: 'Score', body: 'Lower is risky.'),
              ],
              child: Scaffold(
                body: Center(child: SizedBox.square(key: key, dimension: 80)),
              ),
            ),
          ),
        ),
      ),
    );
    // Settle delay, then the tour's fade, morph, and card.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('starts when ready, visible and unseen; Done marks seen', (
    tester,
  ) async {
    final cubit = await pump(tester);
    expect(find.text('Score'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Score'), findsNothing);
    expect(cubit.state.seenTabGuides, contains(TabGuideIds.home));
  });

  testWidgets('waits while the tab has nothing to show', (tester) async {
    await pump(tester, ready: false);
    expect(find.text('Score'), findsNothing);
  });

  testWidgets('stays quiet on a hidden tab', (tester) async {
    await pump(tester, visible: false);
    expect(find.text('Score'), findsNothing);
  });

  testWidgets('does not repeat once seen', (tester) async {
    seen.add(TabGuideIds.home);
    await pump(tester);
    expect(find.text('Score'), findsNothing);
  });

  testWidgets('replay arms the tour again', (tester) async {
    seen.add(TabGuideIds.home);
    when(
      () => prefs.clearSeenTabGuides(),
    ).thenAnswer((_) async => seen.clear());
    final cubit = await pump(tester);
    await cubit.replayTabGuides();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Score'), findsOneWidget);
  });
}
