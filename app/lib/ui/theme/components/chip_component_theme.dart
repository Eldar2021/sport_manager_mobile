import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class ChipComponentTheme {
  static ChipThemeData build(ColorScheme colors, TextTheme textTheme) {
    return ChipThemeData(
      backgroundColor: colors.surfaceContainerHighest,
      selectedColor: colors.primary,
      disabledColor: colors.onSurface.withValues(alpha: AppOpacity.disabledBackground),
      labelStyle: textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: colors.onPrimary),
      side: BorderSide(color: colors.outline),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.chipBorderRadius),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x1),
    );
  }
}
