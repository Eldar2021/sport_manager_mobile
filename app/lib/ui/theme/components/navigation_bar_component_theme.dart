import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/colors/app_colors_extension.dart';
import 'package:sport_manager_mobile/ui/theme/colors/neutral_colors.dart';

abstract final class NavigationBarComponentTheme {
  static NavigationBarThemeData build(
    ColorScheme colors,
    TextTheme textTheme,
    AppColorsExt appColors,
  ) {
    return NavigationBarThemeData(
      backgroundColor: colors.surface,
      indicatorColor: appColors.brandAmberSoft,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colors.primary);
        }
        return IconThemeData(color: colors.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return textTheme.labelMedium?.copyWith(color: colors.primary);
        }
        return textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant);
      }),
      elevation: 0,
      surfaceTintColor: NeutralColors.transparent,
    );
  }
}
