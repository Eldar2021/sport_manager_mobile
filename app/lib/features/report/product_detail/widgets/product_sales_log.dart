import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductSalesLog extends StatelessWidget {
  const ProductSalesLog({
    required this.sales,
    required this.currentPrice,
    super.key,
  });

  final List<ProductSaleModel> sales;
  final int currentPrice;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: sales.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Center(
                child: Text(context.l10n.reportsEmptySubtitle),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: sales.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) {
                return ProductSaleTile(
                  sale: sales[i],
                  currentPrice: currentPrice,
                );
              },
            ),
    );
  }
}
