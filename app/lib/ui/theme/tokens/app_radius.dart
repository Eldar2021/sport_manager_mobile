import 'package:flutter/widgets.dart';

abstract final class AppRadius {
  static const double button = 12;
  static const double input = 12;
  static const double card = 16;
  static const double modal = 20;
  static const double chip = 999;

  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(button));
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(input));
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(card));
  static const BorderRadius chipBorderRadius = BorderRadius.all(Radius.circular(chip));
  static const BorderRadius modalBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(modal),
    topRight: Radius.circular(modal),
  );
}
