import 'package:flutter/widgets.dart';

/// Corner radii from the "Shapes" section of DESIGN.md.
abstract final class AppRadii {
  static const double small = 8;

  /// Micro inputs, nested badges, popovers.
  static const double medium = 12;

  /// Permission tiles and sub-cards inside lists.
  static const double large = 16;

  /// High-level cards, bottom sheets, status cards.
  static const double extraLarge = 28;

  static const double pill = 999;

  static const BorderRadius mediumAll = BorderRadius.all(
    Radius.circular(medium),
  );
  static const BorderRadius largeAll = BorderRadius.all(Radius.circular(large));
  static const BorderRadius extraLargeAll = BorderRadius.all(
    Radius.circular(extraLarge),
  );
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}
