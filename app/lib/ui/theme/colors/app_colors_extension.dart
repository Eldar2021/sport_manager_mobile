import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/colors/neutral_colors.dart';
import 'package:sport_manager_mobile/ui/theme/colors/semantic_colors.dart';

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

  static const AppColorsExt light = AppColorsExt(
    success: SemanticColors.successGreen,
    onSuccess: NeutralColors.white,
    successContainer: SemanticColors.successLight,
    onSuccessContainer: SemanticColors.successDark,
    warning: SemanticColors.warningAmber,
    onWarning: NeutralColors.ink900,
    warningContainer: SemanticColors.warningLight,
    info: SemanticColors.infoCyan,
    onInfo: NeutralColors.white,
    infoContainer: SemanticColors.infoLight,
    brandAmberSoft: Color(0x20D97706),
  );

  static const AppColorsExt dark = AppColorsExt(
    success: SemanticColors.successGreen,
    onSuccess: NeutralColors.white,
    successContainer: SemanticColors.successDark,
    onSuccessContainer: SemanticColors.successLight,
    warning: SemanticColors.warningAmber,
    onWarning: NeutralColors.ink900,
    warningContainer: SemanticColors.warningAmber,
    info: SemanticColors.infoCyan,
    onInfo: NeutralColors.white,
    infoContainer: SemanticColors.infoCyan,
    brandAmberSoft: Color(0x33D97706),
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
    );
  }
}
