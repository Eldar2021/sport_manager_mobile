import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class SnackbarComponentTheme {
  static SnackBarThemeData build(ColorScheme colors, TextTheme textTheme) {
    return SnackBarThemeData(
      backgroundColor: colors.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: colors.onInverseSurface),
      actionTextColor: colors.primary,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardBorderRadius),
    );
  }
}
