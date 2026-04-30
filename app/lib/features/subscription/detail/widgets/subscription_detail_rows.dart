import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
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
    final l10n = context.l10n;
    final dateFmt = DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode);

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: Text(l10n.subscriptionDetailNextPayment),
            trailing: Text(_nextPaymentLabel(context, dateFmt)),
          ),
          const Divider(height: 0),
          ListTile(
            title: Text(l10n.subscriptionDetailLastPayment),
            trailing: Text(_lastPaymentLabel(context, dateFmt)),
          ),
          const Divider(height: 0),
          ListTile(
            title: Text(l10n.subscriptionDetailStatus),
            trailing: Text(_statusLabel(context)),
          ),
        ],
      ),
    );
  }

  String _nextPaymentLabel(BuildContext context, DateFormat dateFmt) {
    if (subscription.status == SubscriptionStatus.expired) return '—';
    return dateFmt.format(subscription.endDate.toLocal());
  }

  String _lastPaymentLabel(BuildContext context, DateFormat dateFmt) {
    final last = lastPayment;
    if (last == null) return '—';
    final date = dateFmt.format((last.paidAt ?? last.createdAt).toLocal());
    final amount = context.l10n.subscriptionAmountWithCurrency(last.amount, last.currency);
    return '$date · $amount';
  }

  String _statusLabel(BuildContext context) => switch (subscription.status) {
    SubscriptionStatus.active => context.l10n.subscriptionStatusActive,
    SubscriptionStatus.grace => context.l10n.subscriptionStatusGrace,
    SubscriptionStatus.expired => context.l10n.subscriptionStatusExpired,
  };
}
