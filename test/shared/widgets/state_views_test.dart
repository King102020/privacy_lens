import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_lens/core/theme/app_theme.dart';
import 'package:privacy_lens/l10n/gen/app_localizations.dart';
import 'package:privacy_lens/shared/widgets/state_views.dart';

void main() {
  testWidgets('error view exposes retry and header semantics', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      _harness(
        ErrorView(message: 'Vault locked', onRetry: () => retried = true),
      ),
    );
    expect(find.text('Vault locked'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('Something went wrong')),
      matchesSemantics(isHeader: true, label: 'Something went wrong'),
    );
    await tester.tap(find.text('Try again'));
    expect(retried, isTrue);
  });

  testWidgets('message view remains reachable at 2.0 text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        const MessageView(
          icon: Icons.shield_outlined,
          title: 'Run your first audit',
          message: 'Nothing leaves this phone.',
          actionLabel: 'Run full audit',
          onAction: _noop,
        ),
        textScale: 2,
      ),
    );
    expect(find.text('Run your first audit'), findsOneWidget);
    expect(find.text('Run full audit'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}

Widget _harness(Widget child, {double textScale = 1}) {
  return MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(body: child),
    ),
  );
}
