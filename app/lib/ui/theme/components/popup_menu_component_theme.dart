import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class PopupMenuComponentTheme {
  static PopupMenuThemeData build(ColorScheme colors, TextTheme textTheme) {
    return PopupMenuThemeData(
      color: colors.surface,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardBorderRadius,
        side: BorderSide(color: colors.outlineVariant),
      ),
      textStyle: textTheme.bodyMedium,
    );
  }
}
