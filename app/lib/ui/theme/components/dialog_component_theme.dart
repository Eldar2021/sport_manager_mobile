import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class DialogComponentTheme {
  static DialogThemeData build(ColorScheme colors, TextTheme textTheme) {
    return DialogThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.modal)),
      ),
      titleTextStyle: textTheme.headlineSmall,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
    );
  }
}
