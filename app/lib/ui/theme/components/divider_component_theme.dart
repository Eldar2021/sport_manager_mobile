import 'package:flutter/material.dart';

abstract final class DividerComponentTheme {
  static DividerThemeData build(ColorScheme colors) {
    return DividerThemeData(
      color: colors.outlineVariant,
      thickness: 1,
      space: 1,
    );
  }
}
