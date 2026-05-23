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
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat('dd MMM yyyy HH:mm', locale).format(sale.soldAt.toLocal());
    final priceStr = _fmt(sale.priceSnapshot, l10n);
    final hasDiff = sale.priceSnapshot != currentPrice;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x1,
      ),
      title: Text(
        date,
        style: context.textTheme.bodyMedium,
      ),
      subtitle: hasDiff
          ? Text(
              l10n.reportsProductPriceAtTime(priceStr, _fmt(currentPrice, l10n)),
              style: context.appTextStyles.muted.labelSmall,
            )
          : null,
      trailing: Text(
        priceStr,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _fmt(int amount, AppLocalizations l10n) =>
      '${NumberFormat('#,##0', 'ru').format(amount)} ${l10n.currencyLabel}';
}
