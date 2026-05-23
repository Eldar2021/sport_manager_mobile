import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductHeaderCard extends StatelessWidget {
  const ProductHeaderCard(this.data, {super.key});

  final ProductSalesSummaryModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final priceFormatted = '${NumberFormat('#,##0', 'ru').format(data.currentPrice)} ${l10n.currencyLabel}';

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: AppRadius.chipBorderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 32,
                  color: context.colors.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.currentName,
                    style: context.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    l10n.reportsProductCurrentPrice(priceFormatted),
                    style: context.appTextStyles.muted.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
