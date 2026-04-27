import 'package:flutter/material.dart';

abstract final class FloatingActionButtonComponentTheme {
  static FloatingActionButtonThemeData build(ColorScheme colors) {
    return FloatingActionButtonThemeData(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      extendedIconLabelSpacing: 10,
      iconSize: 36,
      extendedTextStyle: TextStyle(color: colors.primary),
    );
  }
}
