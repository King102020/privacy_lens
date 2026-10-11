import 'package:flutter/material.dart';

@immutable
class ToneColors {
  const ToneColors({
    required this.accent,
    required this.container,
    required this.onContainer,
  });

  final Color accent;
  final Color container;
  final Color onContainer;

  static ToneColors lerp(ToneColors a, ToneColors b, double t) => ToneColors(
    accent: Color.lerp(a.accent, b.accent, t)!,
    container: Color.lerp(a.container, b.container, t)!,
    onContainer: Color.lerp(a.onContainer, b.onContainer, t)!,
  );
}

@immutable
class SeverityColors extends ThemeExtension<SeverityColors> {
  const SeverityColors({
    required this.low,
    required this.medium,
    required this.high,
  });

  final ToneColors low;
  final ToneColors medium;
  final ToneColors high;

  static const SeverityColors light = SeverityColors(
    low: ToneColors(
      accent: Color(0xFF64748B),
      container: Color(0xFFE2E8F0),
      onContainer: Color(0xFF334155),
    ),
    medium: ToneColors(
      accent: Color(0xFFD97706),
      container: Color(0xFFFEF3C7),
      onContainer: Color(0xFF92400E),
    ),
    high: ToneColors(
      accent: Color(0xFFE11D48),
      container: Color(0xFFFFE4E6),
      onContainer: Color(0xFF9F1239),
    ),
  );

  static const SeverityColors dark = SeverityColors(
    low: ToneColors(
      accent: Color(0xFF94A3B8),
      container: Color(0xFF1E293B),
      onContainer: Color(0xFFE2E8F0),
    ),
    medium: ToneColors(
      accent: Color(0xFFFBBF24),
      container: Color(0xFF78350F),
      onContainer: Color(0xFFFDE68A),
    ),
    high: ToneColors(
      accent: Color(0xFFFB7185),
      container: Color(0xFF881337),
      onContainer: Color(0xFFFECDD3),
    ),
  );

  @override
  SeverityColors copyWith({
    ToneColors? low,
    ToneColors? medium,
    ToneColors? high,
  }) => SeverityColors(
    low: low ?? this.low,
    medium: medium ?? this.medium,
    high: high ?? this.high,
  );

  @override
  SeverityColors lerp(ThemeExtension<SeverityColors>? other, double t) {
    if (other is! SeverityColors) return this;
    return SeverityColors(
      low: ToneColors.lerp(low, other.low, t),
      medium: ToneColors.lerp(medium, other.medium, t),
      high: ToneColors.lerp(high, other.high, t),
    );
  }
}
