import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/tokens/app_radius.dart';
import 'package:sport_manager_mobile/ui/theme/tokens/app_spacing.dart';

abstract final class InputComponentTheme {
  static InputDecorationTheme build(ColorScheme colors, TextTheme textTheme) {
    OutlineInputBorder border(Color color, {double width = 1.5}) {
      return OutlineInputBorder(
        borderRadius: AppRadius.inputBorderRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      border: border(colors.outline),
      enabledBorder: border(colors.outline),
      focusedBorder: border(colors.primary),
      errorBorder: border(colors.error),
      focusedErrorBorder: border(colors.error),
      hintStyle: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
      labelStyle: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
      errorStyle: textTheme.bodySmall?.copyWith(color: colors.error),
    );
  }
}
