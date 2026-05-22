import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductsEmptyView extends StatelessWidget {
  const ProductsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: context.colors.outline,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            context.l10n.productsEmptyTitle,
            style: context.appTextStyles.muted.titleMedium,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            context.l10n.productsEmptySubtitle,
            style: context.appTextStyles.muted.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
