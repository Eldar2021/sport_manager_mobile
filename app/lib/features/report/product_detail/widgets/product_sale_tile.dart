import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductSaleTile extends StatelessWidget {
  const ProductSaleTile({
    required this.sale,
    required this.currentPrice,
    super.key,
  });

  final ProductSaleModel sale;
  final int currentPrice;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat('dd MMM yyyy HH:mm', locale).format(sale.soldAt.toLocal());
    final priceStr = _fmt(sale.priceSnapshot, context.l10n);
    final currentStr = _fmt(currentPrice, context.l10n);
    final hasDiff = sale.priceSnapshot != currentPrice;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: context.textTheme.bodyMedium,
                ),
                if (hasDiff)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.x1),
                    child: Text(
                      context.l10n.reportsProductPriceAtTime(priceStr, currentStr),
                      style: context.appTextStyles.muted.labelSmall,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            priceStr,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int amount, AppLocalizations l10n) =>
      '${NumberFormat('#,##0', 'ru').format(amount)} ${l10n.currencyLabel}';
}
