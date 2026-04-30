import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionPaymentHistory extends StatelessWidget {
  const SubscriptionPaymentHistory({
    required this.payments,
    super.key,
  });

  final List<PaymentModel> payments;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
        child: Center(
          child: Text(
            context.l10n.subscriptionPaymentHistoryEmpty,
            style: context.appTextStyles.muted.bodyMedium,
          ),
        ),
      );
    }
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < payments.length; i++) ...[
            _Item(payment: payments[i]),
            if (i < payments.length - 1) const Divider(height: 0),
          ],
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateFmt = DateFormat('d MMM yyyy', locale);
    final isPaid = payment.status == PaymentStatus.paid;
    final dateValue = isPaid && payment.paidAt != null ? payment.paidAt!.toLocal() : payment.createdAt.toLocal();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFmt.format(dateValue),
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.subscriptionPaymentItemSummary(
                    payment.months,
                    payment.tableCountSnapshot,
                  ),
                  style: context.appTextStyles.muted.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            context.l10n.subscriptionAmountWithCurrency(
              payment.amount,
              payment.currency,
            ),
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _StatusIcon(payment.status),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon(this.status);

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      PaymentStatus.paid => (Icons.check_circle, context.appColors.success),
      PaymentStatus.pending => (Icons.access_time, context.appColors.warning),
      PaymentStatus.failed => (Icons.cancel, context.colors.error),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppOpacity.tint),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x1),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
