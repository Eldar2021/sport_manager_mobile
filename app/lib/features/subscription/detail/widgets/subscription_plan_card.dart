import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/subscription/subscription.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    required this.subscription,
    required this.pricePerTable,
    required this.tableCount,
    required this.currency,
    super.key,
  });

  final SubscriptionModel subscription;
  final int pricePerTable;
  final int tableCount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final monthly = pricePerTable * tableCount;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary,
            context.colors.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.cardBorderRadius,
        boxShadow: context.appColors.shadowMd,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubscriptionStatusBadge(status: subscription.status),
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.subscriptionPlanCardPerTable(pricePerTable, currency),
              style: context.textTheme.headlineMedium?.copyWith(
                color: context.appColors.onSuccess,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.subscriptionPlanCardMonthly(tableCount, monthly, currency),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.appColors.onSuccess.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
