import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/features/report/report.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({
    required this.items,
    required this.venueId,
    super.key,
  });

  final List<ProductReportItemModel> items;
  final String venueId;

  @override
  Widget build(BuildContext context) {
    final maxAmount = items.map((e) => e.totalAmount).reduce((a, b) => a > b ? a : b);
    return Card(
      margin: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          return ProductRow(
            item: items[i],
            maxAmount: maxAmount,
            colorIndex: i,
            venueId: venueId,
          );
        },
      ),
    );
  }
}
