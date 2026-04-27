/// Reusable alpha values used across the theme so widgets stay consistent
/// when they tint, disable, or soften a color.
///
/// Direct use: `someColor.withValues(alpha: AppOpacity.tint)`.
abstract final class AppOpacity {
  /// Tinted background overlay (badges, soft cards, info chips).
  /// Standard across the design system — every `iconColor.withValues(alpha:)`
  /// tinted background uses this.
  static const double tint = 0.12;

  /// Material 3 disabled-foreground convention.
  static const double disabledForeground = 0.38;

  /// Material 3 disabled-background / track convention.
  static const double disabledBackground = 0.12;

  /// Glow drop-shadow under the brand logo. Stronger than `tint` to make
  /// the gradient pop against neutral backgrounds.
  static const double brandGlow = 0.27;
}
