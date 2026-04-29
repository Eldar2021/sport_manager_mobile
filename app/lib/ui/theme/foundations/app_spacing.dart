import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  /// Used 4.0 for spacing between elements, padding, etc.
  static const double x1 = 4;

  /// Used 8.0 for spacing between elements, padding, etc.
  static const double x2 = 8;

  /// Used 12.0 for spacing between elements, padding, etc.
  static const double x3 = 12;

  /// Used 16.0 for spacing between elements, padding, etc.
  static const double x4 = 16;

  /// Used 20.0 for spacing between elements, padding, etc.
  static const double x5 = 20;

  /// Used 24.0 for spacing between elements, padding, etc.
  static const double x6 = 24;

  /// Used 28.0 for spacing between elements, padding, etc.
  static const double x7 = 28;

  /// Used 32.0 for spacing between elements, padding, etc.
  static const double x8 = 32;

  /// Used 40.0 for spacing between elements, padding, etc.
  static const double x10 = 40;

  /// Used 48.0 for spacing between elements, padding, etc.
  static const double x12 = 48;

  /// Used 56.0 for spacing between elements, padding, etc.
  static const double x14 = 56;

  /// Used 64.0 for spacing between elements, padding, etc.
  static const double x16 = 64;

  static double bottom(BuildContext context) {
    return MediaQuery.of(context).viewPadding.bottom + x4;
  }
}
