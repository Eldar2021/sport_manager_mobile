import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SubscriptionTotalCard extends StatelessWidget {
  const SubscriptionTotalCard({
    required this.months,
    required this.monthlyAmount,
    required this.currency,
    required this.newEndDate,
    super.key,
  });

  final int months;
  final int monthlyAmount;
  final String currency;
  final DateTime newEndDate;

  @override
  Widget build(BuildContext context) {
    final total = monthlyAmount * months;
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('d MMMM yyyy', locale).format(newEndDate);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.subscriptionCheckoutTotal,
              style: context.appTextStyles.muted.labelSmall.copyWith(
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.subscriptionAmountWithCurrency(total, currency),
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.subscriptionCheckoutTotalLine(
                months,
                monthlyAmount,
                total,
                currency,
              ),
              style: context.appTextStyles.muted.bodySmall,
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: context.colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  context.l10n.subscriptionCheckoutNewEndDate(dateStr),
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
