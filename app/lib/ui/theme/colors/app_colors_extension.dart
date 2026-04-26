import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Theme-aware colors and shadow tokens that fall outside Material's
/// `ColorScheme`. Read via `Theme.of(context).extension<AppColorsExt>()`
/// (shortcut: `context.appColors`).
@immutable
final class AppColorsExt extends ThemeExtension<AppColorsExt> {
  const AppColorsExt({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.brandAmberSoft,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowLg,
  });

  /// Success / positive state color.
  /// - light: `#65A30D` (`AppColors.successGreen`)
  /// - dark:  `#65A30D` (`AppColors.successGreen`)
  final Color success;

  /// Foreground that goes on top of [success].
  /// - light: `#FFFFFF` (`AppColors.white`)
  /// - dark:  `#FFFFFF` (`AppColors.white`)
  final Color onSuccess;

  /// Filled background for success badges / chips.
  /// - light: `#ECFCCB` (`AppColors.successLight`)
  /// - dark:  `#4D7C0F` (`AppColors.successDark`)
  final Color successContainer;

  /// Foreground for content placed on [successContainer].
  /// - light: `#4D7C0F` (`AppColors.successDark`)
  /// - dark:  `#ECFCCB` (`AppColors.successLight`)
  final Color onSuccessContainer;

  /// Warning color.
  /// - light: `#F59E0B` (`AppColors.warningAmber`)
  /// - dark:  `#F59E0B` (`AppColors.warningAmber`)
  final Color warning;

  /// Foreground that goes on top of [warning].
  /// - light: `#1C1917` (`AppColors.ink900`)
  /// - dark:  `#1C1917` (`AppColors.ink900`)
  final Color onWarning;

  /// Filled background for warning badges / chips.
  /// - light: `#FEF3C7` (`AppColors.warningLight`)
  /// - dark:  `#F59E0B` (`AppColors.warningAmber`)
  final Color warningContainer;

  /// Info color.
  /// - light: `#0891B2` (`AppColors.infoCyan`)
  /// - dark:  `#0891B2` (`AppColors.infoCyan`)
  final Color info;

  /// Foreground that goes on top of [info].
  /// - light: `#FFFFFF` (`AppColors.white`)
  /// - dark:  `#FFFFFF` (`AppColors.white`)
  final Color onInfo;

  /// Filled background for info badges / chips.
  /// - light: `#CFFAFE` (`AppColors.infoLight`)
  /// - dark:  `#155E75` (`AppColors.infoDark`)
  final Color infoContainer;

  /// Soft brand-amber overlay (translucent). Used by NavigationBar indicator.
  /// - light: `#20D97706` (12% alpha, `AppColors.brandAmberSoftLight`)
  /// - dark:  `#33D97706` (20% alpha, `AppColors.brandAmberSoftDark`)
  final Color brandAmberSoft;

  /// Small shadow (sm).
  /// - light: black @ 4% alpha (`AppShadow.smLight`)
  /// - dark:  black @ 20% alpha (`AppShadow.smDark`)
  final List<BoxShadow> shadowSm;

  /// Medium shadow (md).
  /// - light: black @ 8% alpha (`AppShadow.mdLight`)
  /// - dark:  black @ 28% alpha (`AppShadow.mdDark`)
  final List<BoxShadow> shadowMd;

  /// Large shadow (lg).
  /// - light: black @ 12% alpha (`AppShadow.lgLight`)
  /// - dark:  black @ 40% alpha (`AppShadow.lgDark`)
  final List<BoxShadow> shadowLg;

  static const AppColorsExt light = AppColorsExt(
    success: AppColors.successGreen,
    onSuccess: AppColors.white,
    successContainer: AppColors.successLight,
    onSuccessContainer: AppColors.successDark,
    warning: AppColors.warningAmber,
    onWarning: AppColors.ink900,
    warningContainer: AppColors.warningLight,
    info: AppColors.infoCyan,
    onInfo: AppColors.white,
    infoContainer: AppColors.infoLight,
    brandAmberSoft: AppColors.brandAmberSoftLight,
    shadowSm: AppShadow.smLight,
    shadowMd: AppShadow.mdLight,
    shadowLg: AppShadow.lgLight,
  );

  static const AppColorsExt dark = AppColorsExt(
    success: AppColors.successGreen,
    onSuccess: AppColors.white,
    successContainer: AppColors.successDark,
    onSuccessContainer: AppColors.successLight,
    warning: AppColors.warningAmber,
    onWarning: AppColors.ink900,
    warningContainer: AppColors.warningAmber,
    info: AppColors.infoCyan,
    onInfo: AppColors.white,
    infoContainer: AppColors.infoDark,
    brandAmberSoft: AppColors.brandAmberSoftDark,
    shadowSm: AppShadow.smDark,
    shadowMd: AppShadow.mdDark,
    shadowLg: AppShadow.lgDark,
  );

  @override
  AppColorsExt copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? brandAmberSoft,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadowMd,
    List<BoxShadow>? shadowLg,
  }) {
    return AppColorsExt(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      brandAmberSoft: brandAmberSoft ?? this.brandAmberSoft,
      shadowSm: shadowSm ?? this.shadowSm,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowLg: shadowLg ?? this.shadowLg,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      brandAmberSoft: Color.lerp(brandAmberSoft, other.brandAmberSoft, t)!,
      shadowSm: t < 0.5 ? shadowSm : other.shadowSm,
      shadowMd: t < 0.5 ? shadowMd : other.shadowMd,
      shadowLg: t < 0.5 ? shadowLg : other.shadowLg,
    );
  }
}
