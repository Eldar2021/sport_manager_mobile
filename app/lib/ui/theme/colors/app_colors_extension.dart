import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/colors/app_colors.dart';
import 'package:sport_manager_mobile/ui/theme/tokens/app_shadow.dart';

/// Material `ColorScheme` dışında kalan, light/dark'a göre değişen renkler ve
/// gölge token'ları. `Theme.of(context).extension<AppColorsExt>()` ile erişilir
/// (kısa yol: `context.appColors`).
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

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  final Color warning;
  final Color onWarning;
  final Color warningContainer;

  final Color info;
  final Color onInfo;
  final Color infoContainer;

  final Color brandAmberSoft;

  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
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
    infoContainer: AppColors.infoCyan,
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
