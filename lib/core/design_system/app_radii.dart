import 'package:flutter/widgets.dart';

abstract final class AppRadii {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
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
