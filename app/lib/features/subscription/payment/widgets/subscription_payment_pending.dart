import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionPaymentPending extends StatelessWidget {
  const SubscriptionPaymentPending({
    required this.payment,
    required this.onConfirm,
    super.key,
  });

  final PaymentModel payment;
  final ValueChanged<PaymentOutcome> onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Summary(payment),
          const Spacer(),
          AppButton(
            onPressed: () => onConfirm(PaymentOutcome.paid),
            child: Text(context.l10n.subscriptionPaymentSimulateSuccess),
          ),
          const SizedBox(height: AppSpacing.x3),
          AppButton(
            variant: AppButtonVariant.outline,
            onPressed: () => onConfirm(PaymentOutcome.failed),
            child: Text(context.l10n.subscriptionPaymentSimulateFailure),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary(this.payment);

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.brandAmberSoft,
      borderRadius: AppRadius.cardBorderRadius,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.subscriptionPaymentMockSubtitle,
              style: context.appTextStyles.muted.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.subscriptionAmountWithCurrency(
                payment.amount,
                payment.currency,
              ),
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.subscriptionPaymentItemSummary(
                payment.months,
                payment.spotCountSnapshot,
              ),
              style: context.appTextStyles.muted.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
