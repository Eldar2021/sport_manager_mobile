import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class TooltipComponentTheme {
  static TooltipThemeData build(ColorScheme colors, TextTheme textTheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: colors.inverseSurface,
        borderRadius: AppRadius.chipBorderRadius,
      ),
      textStyle: textTheme.labelMedium?.copyWith(
        color: colors.onInverseSurface,
      ),
    );
  }
}
