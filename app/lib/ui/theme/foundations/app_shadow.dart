import 'package:flutter/widgets.dart';
import 'package:sport_manager_mobile/ui/theme/colors/app_colors.dart';

/// Drop-shadow tokens. Light and dark have separate sets — on dark surfaces
/// shadows need a denser black to remain visible.
///
/// Direct use: `AppShadow.mdLight` / `AppShadow.mdDark`.
/// Theme-aware (recommended): `context.appColors.shadowMd`.
abstract final class AppShadow {
  static const List<BoxShadow> smLight = [
    BoxShadow(
      color: AppColors.shadowSmLight,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> mdLight = [
    BoxShadow(
      color: AppColors.shadowMdLight,
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> lgLight = [
    BoxShadow(
      color: AppColors.shadowLgLight,
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> smDark = [
    BoxShadow(
      color: AppColors.shadowSmDark,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> mdDark = [
    BoxShadow(
      color: AppColors.shadowMdDark,
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> lgDark = [
    BoxShadow(
      color: AppColors.shadowLgDark,
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];
}
