import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductCategorySelector extends StatelessWidget {
  const ProductCategorySelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ProductCategory selected;
  final ValueChanged<ProductCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.productsCategoryLabel,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: AppSpacing.x2,
            children: ProductCategory.values
                .map((cat) {
                  return ChoiceChip(
                    avatar: Icon(cat.icon, size: 16),
                    label: Text(cat.localizedName(context.l10n)),
                    selected: cat == selected,
                    showCheckmark: false,
                    onSelected: (_) => onChanged(cat),
                  );
                })
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
