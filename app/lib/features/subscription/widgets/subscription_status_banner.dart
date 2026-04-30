import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionStatusBanner extends StatelessWidget {
  const SubscriptionStatusBanner(this.subscription, {super.key});

  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    final s = subscription;
    final isHardBlock =
        s.status == SubscriptionStatus.expired || (s.status == SubscriptionStatus.grace && s.graceDaysRemaining == 0);
    final isGrace = s.status == SubscriptionStatus.grace && s.graceDaysRemaining > 0;
    final isWarning = s.status == SubscriptionStatus.active && s.daysUntilExpiry <= 3;
    if (!isHardBlock && !isGrace && !isWarning) return const SizedBox.shrink();

    final IconData icon;
    final Color color;
    final String message;
    final bool filled;
    if (isHardBlock) {
      icon = Icons.lock_outline;
      color = context.colors.error;
      message = context.l10n.subscriptionExpiredBanner;
      filled = true;
    } else if (isGrace) {
      icon = Icons.access_time;
      color = context.appColors.warning;
      message = context.l10n.subscriptionGraceBanner(s.graceDaysRemaining);
      filled = false;
    } else {
      icon = Icons.warning_amber_rounded;
      color = context.appColors.warning;
      message = context.l10n.subscriptionWarningBanner(s.daysUntilExpiry);
      filled = false;
    }

    final bg = filled ? color : color.withValues(alpha: AppOpacity.tint);
    final fg = filled ? context.colors.onError : color;

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
            Icon(icon, color: fg),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
