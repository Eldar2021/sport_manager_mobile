import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Shared layout for the success / failure outcome screens of the payment flow.
/// Centered icon (in a tinted circle), title, body, and a single primary button.
class SubscriptionPaymentOutcome extends StatelessWidget {
  const SubscriptionPaymentOutcome({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  factory SubscriptionPaymentOutcome.success(
    BuildContext context, {
    required String body,
    required VoidCallback onClose,
  }) {
    return SubscriptionPaymentOutcome(
      icon: Icons.check_circle,
      color: context.appColors.success,
      title: context.l10n.subscriptionPaymentSuccessTitle,
      body: body,
      actionLabel: context.l10n.subscriptionPaymentClose,
      onAction: onClose,
    );
  }

  factory SubscriptionPaymentOutcome.failed(
    BuildContext context, {
    required VoidCallback onRetry,
  }) {
    return SubscriptionPaymentOutcome(
      icon: Icons.cancel,
      color: context.colors.error,
      title: context.l10n.subscriptionPaymentFailedTitle,
      body: context.l10n.subscriptionPaymentFailedBody,
      actionLabel: context.l10n.subscriptionPaymentRetry,
      onAction: onRetry,
    );
  }

  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: AppOpacity.tint),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Icon(icon, size: 64, color: color),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            title,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            body,
            style: context.appTextStyles.muted.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AppButton(
            onPressed: onAction,
            child: Text(actionLabel),
          ),
          SizedBox(height: AppSpacing.bottom(context)),
        ],
      ),
    );
  }
}
