import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/tokens/app_radius.dart';
import 'package:sport_manager_mobile/ui/theme/typography/app_text_styles.dart';

abstract final class ButtonComponentTheme {
  static const Size _minSize = Size(double.infinity, 56);
  static const RoundedRectangleBorder _shape = RoundedRectangleBorder(
    borderRadius: AppRadius.buttonBorderRadius,
  );

  static FilledButtonThemeData filled(ColorScheme colors) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),
        elevation: 0,
        shape: _shape,
        minimumSize: _minSize,
        textStyle: AppTextStyles.button,
      ),
    );
  }

  static ElevatedButtonThemeData elevated(ColorScheme colors) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),
        elevation: 0,
        shape: _shape,
        minimumSize: _minSize,
        textStyle: AppTextStyles.button,
      ),
    );
  }

  static OutlinedButtonThemeData outlined(ColorScheme colors) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: colors.surfaceContainerHighest,
        foregroundColor: colors.onSurface,
        disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),
        side: BorderSide.none,
        elevation: 0,
        shape: _shape,
        minimumSize: _minSize,
        textStyle: AppTextStyles.button,
      ),
    );
  }

  static TextButtonThemeData text(ColorScheme colors) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: colors.primary,
        disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),
        shape: _shape,
        textStyle: AppTextStyles.button,
      ),
    );
  }
}
