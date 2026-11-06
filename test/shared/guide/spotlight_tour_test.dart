import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_lens/core/theme/app_theme.dart';
import 'package:privacy_lens/l10n/gen/app_localizations.dart';
import 'package:privacy_lens/shared/guide/spotlight_tour.dart';

void main() {
  final first = GlobalKey();
  final second = GlobalKey();
  final missing = GlobalKey();

  Future<Future<bool?>> start(
    WidgetTester tester,
    List<TourStep> Function() steps,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (ctx) {
            context = ctx;
            return Scaffold(
              body: Column(
                children: [
                  SizedBox(key: first, height: 60, width: 200),
                  const SizedBox(height: 300),
                  SizedBox(key: second, height: 60, width: 200),
                ],
              ),
            );
          },
        ),
      ),
    );
    final result = showSpotlightTour(context, steps());
    await tester.pumpAndSettle();
    return result;
  }

  TourStep step(GlobalKey key, String title) =>
      TourStep(target: key, title: title, body: '$title body');

  testWidgets('walks the steps and returns true on Done', (tester) async {
    final result = await start(
      tester,
      () => [step(first, 'One'), step(second, 'Two')],
    );
    expect(find.text('One'), findsOneWidget);
    expect(find.text('1 of 2'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
    expect(isSpotlightTourOpen, isFalse);
  });

  testWidgets('Skip returns false', (tester) async {
    final result = await start(
      tester,
      () => [step(first, 'One'), step(second, 'Two')],
    );
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
    expect(find.text('One'), findsNothing);
  });

  testWidgets('back counts as skip', (tester) async {
    final result = await start(
      tester,
      () => [step(first, 'One'), step(second, 'Two')],
    );
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();
    expect(await result, isFalse);
  });

  testWidgets('leaves out targets that are not on screen', (tester) async {
    final result = await start(
      tester,
      () => [step(missing, 'Gone'), step(first, 'One')],
    );
    expect(find.text('Gone'), findsNothing);
    expect(find.text('1 of 1'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
  });

  testWidgets('shows nothing when no target exists', (tester) async {
    final result = await start(tester, () => [step(missing, 'Gone')]);
    expect(await result, isNull);
    expect(find.text('Gone'), findsNothing);
  });
}
