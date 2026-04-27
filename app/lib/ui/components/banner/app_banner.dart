import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Visual style of [AppBanner].
///
/// - [hint]    soft tinted overlay on top of `primary` — for inline help text
///             under form fields. Lighter weight than [info].
/// - [info]    filled `primaryContainer` — for prominent informational notices.
enum AppBannerVariant { hint, info }

/// Tinted notice with a leading icon and a body of text.
///
/// Pick a [variant] for the visual weight; `hint` is soft / tinted, `info`
/// is a filled container. Both pull colors from the active `ColorScheme`
/// so they adapt to light/dark automatically.
class AppBanner extends StatelessWidget {
  const AppBanner(
    this.text, {
    this.variant = AppBannerVariant.hint,
    this.icon = Icons.info_outline_rounded,
    super.key,
  });

  final String text;
  final AppBannerVariant variant;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (bg, fg) = switch (variant) {
      AppBannerVariant.hint => (
        colors.primary.withValues(alpha: AppOpacity.tint),
        colors.primary,
      ),
      AppBannerVariant.info => (colors.primaryContainer, colors.onPrimaryContainer),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: context.textTheme.bodySmall?.copyWith(
                  color: fg,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
