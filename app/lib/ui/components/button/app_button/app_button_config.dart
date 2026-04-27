part of 'app_button.dart';

/// Visual variants supported by `AppButton`.
enum AppButtonVariant {
  /// Filled, high-emphasis primary action.
  primary,

  /// Filled, lower-emphasis tonal action.
  secondary,

  /// Transparent background with a border.
  outline,
}

/// Predefined sizes for `AppButton`.
enum AppButtonSize { small, medium, large }

/// Resolved size tokens for a single [AppButtonSize].
@immutable
class AppButtonSizeConfig {
  const AppButtonSizeConfig({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
    required this.fontWeight,
    required this.iconSize,
    required this.iconGap,
    required this.borderRadius,
    required this.loadingIndicatorSize,
  });

  final double height;
  final double horizontalPadding;
  final double fontSize;
  final FontWeight fontWeight;
  final double iconSize;
  final double iconGap;
  final double borderRadius;
  final double loadingIndicatorSize;

  static const AppButtonSizeConfig small = AppButtonSizeConfig(
    height: 40,
    horizontalPadding: 12,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    iconSize: 18,
    iconGap: 6,
    borderRadius: 12,
    loadingIndicatorSize: 16,
  );

  static const AppButtonSizeConfig medium = AppButtonSizeConfig(
    height: 48,
    horizontalPadding: 16,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    iconSize: 20,
    iconGap: 8,
    borderRadius: 14,
    loadingIndicatorSize: 20,
  );

  static const AppButtonSizeConfig large = AppButtonSizeConfig(
    height: 56,
    horizontalPadding: 20,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    iconSize: 22,
    iconGap: 8,
    borderRadius: 16,
    loadingIndicatorSize: 22,
  );

  static AppButtonSizeConfig of(AppButtonSize size) {
    return switch (size) {
      AppButtonSize.small => small,
      AppButtonSize.medium => medium,
      AppButtonSize.large => large,
    };
  }
}
