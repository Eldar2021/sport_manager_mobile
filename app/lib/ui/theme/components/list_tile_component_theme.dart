import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/colors/neutral_colors.dart';
import 'package:sport_manager_mobile/ui/theme/tokens/app_radius.dart';
import 'package:sport_manager_mobile/ui/theme/tokens/app_spacing.dart';

abstract final class ListTileComponentTheme {
  static ListTileThemeData build(ColorScheme colors) {
    return ListTileThemeData(
      tileColor: NeutralColors.transparent,
      textColor: colors.onSurface,
      iconColor: colors.onSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardBorderRadius),
    );
  }
}
