import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/colors/app_colors_extension.dart';
import 'package:sport_manager_mobile/ui/theme/typography/app_text_theme_extension.dart';

extension AppThemeContextExt on BuildContext {
  ThemeData get appTheme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  AppColorsExt get appColors => Theme.of(this).extension<AppColorsExt>()!;

  AppTextThemeExt get appTextStyles => Theme.of(this).extension<AppTextThemeExt>()!;
}
