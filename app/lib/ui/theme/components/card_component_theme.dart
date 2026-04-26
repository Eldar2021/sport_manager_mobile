import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/tokens/app_radius.dart';

abstract final class CardComponentTheme {
  static CardThemeData build(ColorScheme colors) {
    return CardThemeData(
      color: colors.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardBorderRadius),
      margin: EdgeInsets.zero,
    );
  }
}
