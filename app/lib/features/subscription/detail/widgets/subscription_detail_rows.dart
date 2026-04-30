import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionDetailRows extends StatelessWidget {
  const SubscriptionDetailRows({
    required this.subscription,
    required this.lastPayment,
    super.key,
  });

  final SubscriptionModel subscription;
  final PaymentModel? lastPayment;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateFmt = DateFormat('d MMMM yyyy', locale);
    final last = lastPayment;
    final lastValue = last == null
        ? '—'
        : '${dateFmt.format(last.paidAt?.toLocal() ?? last.createdAt.toLocal())} · '
              '${context.l10n.subscriptionAmountWithCurrency(last.amount, last.currency)}';
    final statusLabel = switch (subscription.status) {
      SubscriptionStatus.active => context.l10n.subscriptionStatusActive,
      SubscriptionStatus.grace => context.l10n.subscriptionStatusGrace,
      SubscriptionStatus.expired => context.l10n.subscriptionStatusExpired,
    };
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x2,
        ),
        child: Column(
          children: [
            _Row(
              label: context.l10n.subscriptionDetailNextPayment,
              value: subscription.status == SubscriptionStatus.expired
                  ? '—'
                  : dateFmt.format(subscription.endDate.toLocal()),
            ),
            const Divider(height: AppSpacing.x4),
            _Row(label: context.l10n.subscriptionDetailLastPayment, value: lastValue),
            const Divider(height: AppSpacing.x4),
            _Row(label: context.l10n.subscriptionDetailStatus, value: statusLabel),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.appTextStyles.muted.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
