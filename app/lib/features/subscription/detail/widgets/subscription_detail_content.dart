import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/subscription/subscription.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionDetailContent extends StatelessWidget {
  const SubscriptionDetailContent(this.detail, {super.key});

  final SubscriptionDetailModel detail;

  PaymentModel? get _lastPaid => detail.payments.where((p) {
    return p.status == PaymentStatus.paid;
  }).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final s = detail.subscription;
    final last = _lastPaid;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        kAppButtonFabClearance,
      ),
      children: [
        if (s.alert != SubscriptionAlert.none) ...[
          SubscriptionStatusBanner(s),
          const SizedBox(height: AppSpacing.x4),
        ],
        SubscriptionPlanCard(
          subscription: s,
          pricePerTable: last?.pricePerTableSnapshot ?? 0,
          tableCount: last?.tableCountSnapshot ?? 0,
          currency: last?.currency ?? 'KGS',
        ),
        const SizedBox(height: AppSpacing.x4),
        SubscriptionDetailRows(
          subscription: s,
          lastPayment: last,
        ),
        const SizedBox(height: AppSpacing.x6),
        Text(
          context.l10n.subscriptionPaymentHistoryTitle,
          style: context.appTextStyles.muted.labelSmall.copyWith(
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        SubscriptionPaymentHistory(detail.payments),
      ],
    );
  }
}
