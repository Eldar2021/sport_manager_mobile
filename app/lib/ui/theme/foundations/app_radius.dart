import 'package:flutter/widgets.dart';

abstract final class AppRadius {
  static const checkbox = 6.0;
  static const button = 12.0;
  static const input = 12.0;
  static const card = 16.0;
  static const modal = 20.0;
  static const chip = 999.0;

  static const checkboxBorderRadius = BorderRadius.all(Radius.circular(checkbox));
  static const buttonBorderRadius = BorderRadius.all(Radius.circular(button));
  static const inputBorderRadius = BorderRadius.all(Radius.circular(input));
  static const cardBorderRadius = BorderRadius.all(Radius.circular(card));
  static const chipBorderRadius = BorderRadius.all(Radius.circular(chip));

  static const modalBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(modal),
    topRight: Radius.circular(modal),
  );
}
