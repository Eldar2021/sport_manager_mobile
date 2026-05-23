import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class PriceHistoryCard extends StatelessWidget {
  const PriceHistoryCard({
    required this.prices,
    required this.currentPrice,
    super.key,
  });

  final List<int> prices;
  final int currentPrice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reportsProductPriceHistoryTitle,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              l10n.reportsProductPriceHistorySubtitle(prices.length),
              style: context.appTextStyles.muted.labelSmall,
            ),
            const SizedBox(height: AppSpacing.x3),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                for (final price in prices)
                  _PriceChip(
                    price: price,
                    isCurrent: price == currentPrice,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({
    required this.price,
    required this.isCurrent,
  });

  final int price;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formatted = '${NumberFormat('#,##0', 'ru').format(price)} ${l10n.currencyLabel}';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCurrent
            ? context.colors.primary.withValues(
                alpha: AppOpacity.tint,
              )
            : context.colors.surfaceContainerHighest,
        borderRadius: AppRadius.chipBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatted,
              style: context.textTheme.bodySmall?.copyWith(
                color: isCurrent ? context.colors.primary : null,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isCurrent) ...[
              const SizedBox(width: AppSpacing.x2),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: AppRadius.chipBorderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x2,
                    vertical: 2,
                  ),
                  child: Text(
                    l10n.reportsProductPriceNowBadge,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colors.onPrimary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
