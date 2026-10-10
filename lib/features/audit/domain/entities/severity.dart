enum Severity {
  low,
  medium,
  high;

  bool isAtLeast(Severity other) => index >= other.index;

  static Severity? highest(Iterable<Severity> values) {
    Severity? result;
    for (final value in values) {
      if (result == null || value.index > result.index) result = value;
    }
    return result;
  }
}

/// Per-app risk. `minimal` means no rule produced a finding.
enum RiskLevel {
  minimal,
  low,
  medium,
  high;

  static RiskLevel fromSeverity(Severity? severity) => switch (severity) {
    null => RiskLevel.minimal,
    Severity.low => RiskLevel.low,
    Severity.medium => RiskLevel.medium,
    Severity.high => RiskLevel.high,
  };
}
