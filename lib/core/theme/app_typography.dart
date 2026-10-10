import 'package:flutter/material.dart';

/// Inter type scale from DESIGN.md. Line heights are expressed as
/// `lineHeight / fontSize` because Flutter's `height` is a multiplier.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';

  static TextTheme textTheme(Color onSurface) {
    TextStyle style(
      double size,
      double lineHeight,
      FontWeight weight,
      double letterSpacing,
    ) => TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      color: onSurface,
    );

    return TextTheme(
      displayLarge: style(57, 64, FontWeight.w400, -0.25),
      displayMedium: style(45, 52, FontWeight.w400, 0),
      displaySmall: style(36, 44, FontWeight.w400, 0),
      headlineLarge: style(32, 40, FontWeight.w600, -0.5),
      headlineMedium: style(24, 32, FontWeight.w600, -0.2),
      headlineSmall: style(20, 28, FontWeight.w600, 0),
      titleLarge: style(20, 26, FontWeight.w500, 0),
      titleMedium: style(16, 24, FontWeight.w500, 0.15),
      titleSmall: style(14, 20, FontWeight.w500, 0.1),
      bodyLarge: style(16, 24, FontWeight.w400, 0.5),
      bodyMedium: style(14, 20, FontWeight.w400, 0.25),
      bodySmall: style(12, 16, FontWeight.w400, 0.4),
      labelLarge: style(14, 20, FontWeight.w500, 0.1),
      labelMedium: style(12, 16, FontWeight.w500, 0.5),
      labelSmall: style(11, 16, FontWeight.w600, 0.5),
    );
  }

  /// Timestamps and counts use tabular figures so columns stay aligned.
  static TextStyle? tabular(TextStyle? style) =>
      style?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
