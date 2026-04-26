import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/colors/neutral_colors.dart';

abstract final class SwitchComponentTheme {
  static SwitchThemeData build(ColorScheme colors) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return NeutralColors.white;
        return colors.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colors.primary;
        return colors.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return NeutralColors.transparent;
        return colors.outline;
      }),
    );
  }
}
