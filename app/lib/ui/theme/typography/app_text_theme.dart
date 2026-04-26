import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/typography/app_text_styles.dart';

abstract final class AppTextTheme {
  static TextTheme build(Color textColor) {
    return TextTheme(
      displayLarge: AppTextStyles.display,
      displayMedium: AppTextStyles.display,
      displaySmall: AppTextStyles.amount,
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      headlineSmall: AppTextStyles.h3,
      titleLarge: AppTextStyles.h2,
      titleMedium: AppTextStyles.h3,
      titleSmall: AppTextStyles.bodyBold,
      bodyLarge: AppTextStyles.bodyBold,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.button,
      labelMedium: AppTextStyles.caption,
      labelSmall: AppTextStyles.caption,
    ).apply(bodyColor: textColor, displayColor: textColor);
  }
}
