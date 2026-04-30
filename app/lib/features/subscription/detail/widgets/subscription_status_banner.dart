import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionStatusBanner extends StatelessWidget {
  const SubscriptionStatusBanner(this.subscription, {super.key});

  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    return switch (subscription.alert) {
      SubscriptionAlert.none => const SizedBox.shrink(),
      SubscriptionAlert.warning => _Banner(
        icon: Icons.warning_amber_rounded,
        color: context.appColors.warning,
        message: context.l10n.subscriptionWarningBanner(
          subscription.daysUntilExpiry,
        ),
      ),
      SubscriptionAlert.grace => _Banner(
        icon: Icons.access_time,
        color: context.appColors.warning,
        message: context.l10n.subscriptionGraceBanner(
          subscription.graceDaysRemaining,
        ),
      ),
      SubscriptionAlert.expired => _Banner(
        icon: Icons.lock_outline,
        color: context.colors.error,
        message: context.l10n.subscriptionExpiredBanner,
        filled: true,
      ),
    };
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.color,
    required this.message,
    this.filled = false,
  });

  final IconData icon;
  final Color color;
  final String message;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? context.colors.onError : color;
    return Material(
      color: filled ? color : color.withValues(alpha: AppOpacity.tint),
      borderRadius: AppRadius.cardBorderRadius,
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
