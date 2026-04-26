import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class SwitchComponentTheme {
  static SwitchThemeData build(ColorScheme colors) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.white;
        return colors.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colors.primary;
        return colors.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.transparent;
        return colors.outline;
      }),
    );
  }
}
