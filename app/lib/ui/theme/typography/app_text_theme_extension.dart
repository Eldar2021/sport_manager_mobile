import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/typography/app_text_theme.dart';

/// Theme'in error / disabled / muted renkleriyle önceden boyanmış tam metin
/// stili setleri. `context.appTextStyles.error.bodyMedium` gibi kullanılır —
/// böylece widget'larda `style.copyWith(color: ...)` zincirleri kalmaz.
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

  /// Hata renginde tüm stiller (form errorları, validation mesajları vb.).
  final AppTextTheme error;

  /// Disabled durumda tüm stiller (onSurface @ %38 opacity).
  final AppTextTheme disabled;

  /// Yardımcı / ikincil metin (onSurfaceVariant).
  final AppTextTheme muted;

  /// Primary üzerine yazılan metin (FilledButton, badge vb.).
  final AppTextTheme onPrimary;

  /// Link stili (underline + primary color).
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
