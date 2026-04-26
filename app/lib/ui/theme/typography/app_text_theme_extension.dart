import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/typography/app_text_styles.dart';

@immutable
final class AppTextThemeExt extends ThemeExtension<AppTextThemeExt> {
  const AppTextThemeExt({
    required this.bodyError,
    required this.bodyDisabled,
    required this.bodyMuted,
    required this.captionError,
    required this.captionMuted,
    required this.link,
  });

  factory AppTextThemeExt.from({
    required TextTheme textTheme,
    required ColorScheme colors,
  }) {
    final body = textTheme.bodyMedium ?? AppTextStyles.body;
    final caption = textTheme.bodySmall ?? AppTextStyles.caption;
    return AppTextThemeExt(
      bodyError: body.copyWith(color: colors.error),
      bodyDisabled: body.copyWith(color: colors.onSurface.withValues(alpha: 0.38)),
      bodyMuted: body.copyWith(color: colors.onSurfaceVariant),
      captionError: caption.copyWith(color: colors.error),
      captionMuted: caption.copyWith(color: colors.onSurfaceVariant),
      link: body.copyWith(color: colors.primary, decoration: TextDecoration.underline),
    );
  }

  final TextStyle bodyError;
  final TextStyle bodyDisabled;
  final TextStyle bodyMuted;
  final TextStyle captionError;
  final TextStyle captionMuted;
  final TextStyle link;

  @override
  AppTextThemeExt copyWith({
    TextStyle? bodyError,
    TextStyle? bodyDisabled,
    TextStyle? bodyMuted,
    TextStyle? captionError,
    TextStyle? captionMuted,
    TextStyle? link,
  }) {
    return AppTextThemeExt(
      bodyError: bodyError ?? this.bodyError,
      bodyDisabled: bodyDisabled ?? this.bodyDisabled,
      bodyMuted: bodyMuted ?? this.bodyMuted,
      captionError: captionError ?? this.captionError,
      captionMuted: captionMuted ?? this.captionMuted,
      link: link ?? this.link,
    );
  }

  @override
  AppTextThemeExt lerp(ThemeExtension<AppTextThemeExt>? other, double t) {
    if (other is! AppTextThemeExt) return this;
    return AppTextThemeExt(
      bodyError: TextStyle.lerp(bodyError, other.bodyError, t)!,
      bodyDisabled: TextStyle.lerp(bodyDisabled, other.bodyDisabled, t)!,
      bodyMuted: TextStyle.lerp(bodyMuted, other.bodyMuted, t)!,
      captionError: TextStyle.lerp(captionError, other.captionError, t)!,
      captionMuted: TextStyle.lerp(captionMuted, other.captionMuted, t)!,
      link: TextStyle.lerp(link, other.link, t)!,
    );
  }
}
