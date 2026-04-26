import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

enum AppBadgeVariant { success, info, error }

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    this.icon,
    this.variant = AppBadgeVariant.info,
    super.key,
  });

  final String label;
  final IconData? icon;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final (color, bg) = switch (variant) {
      AppBadgeVariant.success => (AppColors.successGreen, AppColors.successLight),
      AppBadgeVariant.info => (AppColors.brandAmber, AppColors.brandAmberLight),
      AppBadgeVariant.error => (AppColors.dangerRed, AppColors.dangerLight),
    };

    return DecoratedBox(
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.chipBorderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, color: color, size: 14), const SizedBox(width: AppSpacing.x1)],
            Text(
              label.toUpperCase(),
              style: context.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
