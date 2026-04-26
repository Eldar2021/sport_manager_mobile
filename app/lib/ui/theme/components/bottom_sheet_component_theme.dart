import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/colors/app_colors.dart';
import 'package:sport_manager_mobile/ui/theme/tokens/app_radius.dart';

abstract final class BottomSheetComponentTheme {
  static BottomSheetThemeData build(ColorScheme colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.modalBorderRadius),
      showDragHandle: true,
      dragHandleColor: colors.outline,
    );
  }
}
