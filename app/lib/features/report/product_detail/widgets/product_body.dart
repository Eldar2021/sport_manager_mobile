import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductBody extends StatelessWidget {
  const ProductBody(this.data, {super.key});

  final ProductSalesSummaryModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final uniquePrices = data.sales.map((s) => s.priceSnapshot).toSet().toList()..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (data.deleted)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x4),
            child: AppBanner(
              l10n.productDeletedBadge,
              variant: AppBannerVariant.info,
            ),
          ),
        ProductHeaderCard(data),
        const SizedBox(height: AppSpacing.x3),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ReportKpiCard(
                  title: l10n.reportsProductSoldLabel,
                  value: '${data.totalCount} ${l10n.productUnitPieceShort}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: ReportKpiCard(
                  title: l10n.reportsProductRevenueLabel,
                  value: '${NumberFormat('#,##0', 'ru').format(data.totalAmount)} ${l10n.currencyLabel}',
                ),
              ),
            ],
          ),
        ),
        if (uniquePrices.length > 1) ...[
          const SizedBox(height: AppSpacing.x3),
          PriceHistoryCard(
            prices: uniquePrices,
            currentPrice: data.currentPrice,
          ),
        ],
        const SizedBox(height: AppSpacing.x4),
        Text(
          l10n.reportsProductSalesLogTitle,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        ProductSalesLog(
          sales: data.sales,
          currentPrice: data.currentPrice,
        ),
      ],
    );
  }
}
