import 'package:flutter/material.dart';

import '../../core/theme/severity_colors.dart';
import '../../l10n/gen/app_localizations.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textStyles => Theme.of(this).textTheme;

  SeverityColors get severityColors =>
      Theme.of(this).extension<SeverityColors>() ?? SeverityColors.light;

  void showSnack(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
