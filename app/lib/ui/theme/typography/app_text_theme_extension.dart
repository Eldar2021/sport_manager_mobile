import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/typography/app_text_theme.dart';

/// Pre-baked text style sets for the theme's error / disabled / muted /
/// onPrimary roles. Use as `context.appTextStyles.error.bodyMedium` so
/// widgets stop chaining `style.copyWith(color: ...)` everywhere.
@immutable
final class AppTextThemeExt extends ThemeExtension<AppTextThemeExt> {
  const AppTextThemeExt({
    required this.error,
    required this.disabled,
    required this.muted,
    required this.onPrimary,
    required this.link,
  });

  factory AppTextThemeExt.from({required ColorScheme colors}) {
    return AppTextThemeExt(
      error: AppTextTheme.from(colors.error),
      disabled: AppTextTheme.from(colors.onSurface.withValues(alpha: 0.38)),
      muted: AppTextTheme.from(colors.onSurfaceVariant),
      onPrimary: AppTextTheme.from(colors.onPrimary),
      link: AppTextTheme.from(colors.primary).bodyMedium.copyWith(
        decoration: TextDecoration.underline,
        decorationColor: colors.primary,
      ),
    );
  }

  /// Full text-style set painted with `colorScheme.error`.
  /// Use for form errors, validation messages, destructive copy.
  final AppTextTheme error;

  /// Full text-style set painted with `onSurface @ 38%` opacity.
  /// Use for disabled controls / placeholder content.
  final AppTextTheme disabled;

  /// Full text-style set painted with `colorScheme.onSurfaceVariant`.
  /// Use for helper text, secondary labels, muted captions.
  final AppTextTheme muted;

  /// Full text-style set painted with `colorScheme.onPrimary`.
  /// Use when text sits on top of a primary-colored surface (FilledButton,
  /// badge, banner).
  final AppTextTheme onPrimary;

  /// Underlined body style in `colorScheme.primary` — for tappable links.
  final TextStyle link;

  @override
  AppTextThemeExt copyWith({
    AppTextTheme? error,
    AppTextTheme? disabled,
    AppTextTheme? muted,
    AppTextTheme? onPrimary,
    TextStyle? link,
  }) {
    return AppTextThemeExt(
      error: error ?? this.error,
      disabled: disabled ?? this.disabled,
      muted: muted ?? this.muted,
      onPrimary: onPrimary ?? this.onPrimary,
      link: link ?? this.link,
    );
  }

  @override
  AppTextThemeExt lerp(ThemeExtension<AppTextThemeExt>? other, double t) {
    if (other is! AppTextThemeExt) return this;
    return AppTextThemeExt(
      error: AppTextTheme.lerp(error, other.error, t),
      disabled: AppTextTheme.lerp(disabled, other.disabled, t),
      muted: AppTextTheme.lerp(muted, other.muted, t),
      onPrimary: AppTextTheme.lerp(onPrimary, other.onPrimary, t),
      link: TextStyle.lerp(link, other.link, t)!,
    );
  }
}
