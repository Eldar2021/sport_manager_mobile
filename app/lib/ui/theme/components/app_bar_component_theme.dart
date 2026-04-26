import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class AppBarComponentTheme {
  static AppBarTheme build(ColorScheme colors, TextTheme textTheme) {
    final isDark = colors.brightness == Brightness.dark;
    return AppBarTheme(
      backgroundColor: colors.surfaceContainerLow,
      foregroundColor: colors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
        statusBarColor: AppColors.transparent,
      ),
      titleTextStyle: textTheme.titleLarge,
      iconTheme: IconThemeData(color: colors.primary),
      surfaceTintColor: AppColors.transparent,
    );
  }
}
