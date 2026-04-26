import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class ButtonComponentTheme {
  static const Size _minSize = Size(double.infinity, 56);

  static const RoundedRectangleBorder _shape = RoundedRectangleBorder(
    borderRadius: AppRadius.buttonBorderRadius,
  );

  static FilledButtonThemeData filled(ColorScheme colors, TextTheme textTheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.onSurface.withValues(alpha: AppOpacity.disabledBackground),
        disabledForegroundColor: colors.onSurface.withValues(alpha: AppOpacity.disabledForeground),
        elevation: 0,
        shape: _shape,
        minimumSize: _minSize,
        textStyle: textTheme.labelLarge,
      ),
    );
  }

  static ElevatedButtonThemeData elevated(ColorScheme colors, TextTheme textTheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.onSurface.withValues(alpha: AppOpacity.disabledBackground),
        disabledForegroundColor: colors.onSurface.withValues(alpha: AppOpacity.disabledForeground),
        elevation: 0,
        shape: _shape,
        minimumSize: _minSize,
        textStyle: textTheme.labelLarge,
      ),
    );
  }

  static OutlinedButtonThemeData outlined(ColorScheme colors, TextTheme textTheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: colors.surfaceContainerHighest,
        foregroundColor: colors.onSurface,
        disabledForegroundColor: colors.onSurface.withValues(alpha: AppOpacity.disabledForeground),
        side: BorderSide.none,
        elevation: 0,
        shape: _shape,
        minimumSize: _minSize,
        textStyle: textTheme.labelLarge,
      ),
    );
  }

  static TextButtonThemeData text(ColorScheme colors, TextTheme textTheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: colors.primary,
        disabledForegroundColor: colors.onSurface.withValues(alpha: AppOpacity.disabledForeground),
        shape: _shape,
        textStyle: textTheme.labelLarge,
      ),
    );
  }
}
