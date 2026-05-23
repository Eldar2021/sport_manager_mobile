import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/features/product/product.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductsListCard extends StatelessWidget {
  const ProductsListCard({
    required this.data,
    required this.deletingId,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<ProductModel> data;
  final String? deletingId;
  final ValueChanged<ProductModel> onEdit;
  final ValueChanged<ProductModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x2,
        AppSpacing.x4,
        kAppButtonFabClearance,
      ),
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ListTile.divideTiles(
              context: context,
              tiles: data.map(
                (product) => ProductTile(
                  product,
                  key: ValueKey(product.id),
                  isDeleting: deletingId == product.id,
                  onEdit: () => onEdit(product),
                  onDelete: () => onDelete(product),
                ),
              ),
            ).toList(growable: false),
          ),
        ),
      ],
    );
  }
}
