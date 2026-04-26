import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppInfoBanner extends StatelessWidget {
  const AppInfoBanner(
    this.text, {
    this.icon = Icons.info_outline_rounded,
    super.key,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: AppOpacity.tint),
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.primary, size: 18),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.primary,
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
