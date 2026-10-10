abstract final class AppDimensions {
  static const double minTouchTarget = 48;
  static const double primaryButtonHeight = 56;
  static const double filterChipHeight = 32;
  static const double appIconSize = 48;
  static const double appIconSizeLarge = 64;
  static const double iconContainerSize = 40;
  static const double postureRingSize = 72;
  static const double postureRingStroke = 6;
  static const double usageBarHeight = 8;
  static const double hourlyChartHeight = 96;

  /// Icons are decoded at this size so a long app list stays light on memory.
  static const int appIconCacheSize = 128;
}

/// Width breakpoints from the "Layout & Spacing" section of DESIGN.md.
abstract final class AppBreakpoints {
  static const double medium = 600;
  static const double expanded = 840;
  static const double maxContentWidth = 1080;
  static const double listPaneWidth = 380;
}
