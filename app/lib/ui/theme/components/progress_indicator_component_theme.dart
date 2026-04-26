import 'package:flutter/material.dart';

abstract final class ProgressIndicatorComponentTheme {
  static ProgressIndicatorThemeData build(ColorScheme colors) {
    return ProgressIndicatorThemeData(
      color: colors.primary,
      linearTrackColor: colors.surfaceContainerHighest,
      circularTrackColor: colors.surfaceContainerHighest,
    );
  }
}
