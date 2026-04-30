import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionPaymentHistory extends StatelessWidget {
  const SubscriptionPaymentHistory(this.payments, {super.key});

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
            _PaymentTile(payments[i]),
            if (i < payments.length - 1) const Divider(height: 0),
          ],
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile(this.payment);

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateFmt = DateFormat('d MMM yyyy', locale);
    final date = (payment.paidAt ?? payment.createdAt).toLocal();
    return ListTile(
      title: Text(dateFmt.format(date)),
      subtitle: Text(
        context.l10n.subscriptionPaymentItemSummary(
          payment.months,
          payment.tableCountSnapshot,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          _StatusDot(payment.status),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot(this.status);

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      PaymentStatus.paid => (
        Icons.check_circle,
        context.appColors.success,
      ),
      PaymentStatus.pending => (
        Icons.access_time,
        context.appColors.warning,
      ),
      PaymentStatus.failed => (
        Icons.cancel,
        context.colors.error,
      ),
    };
    return Icon(
      icon,
      size: 20,
      color: color,
    );
  }
}
