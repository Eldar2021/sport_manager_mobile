import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionStatusBadge extends StatelessWidget {
  const SubscriptionStatusBadge({
    required this.status,
    super.key,
  });

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, fg) = switch (status) {
      SubscriptionStatus.active => (
        context.l10n.subscriptionStatusActive,
        context.appColors.success,
      ),
      SubscriptionStatus.grace => (
        context.l10n.subscriptionStatusGrace,
        context.appColors.warning,
      ),
      SubscriptionStatus.expired => (
        context.l10n.subscriptionStatusExpired,
        context.colors.error,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fg.withValues(alpha: AppOpacity.tint),
        borderRadius: AppRadius.chipBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: fg),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label.toUpperCase(),
              style: context.textTheme.labelSmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
