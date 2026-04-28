import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class FloatingActionButtonComponentTheme {
  static FloatingActionButtonThemeData build(ColorScheme colors, TextTheme textTheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      extendedIconLabelSpacing: AppSpacing.x3,
      iconSize: AppSpacing.x8,
      extendedTextStyle: textTheme.labelLarge?.copyWith(
        color: colors.onPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
