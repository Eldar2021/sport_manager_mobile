import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductUnitSelector extends StatelessWidget {
  const ProductUnitSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ProductUnit selected;
  final ValueChanged<ProductUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.productsUnitLabel,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: ProductUnit.values
              .map((unit) {
                final isSelected = unit == selected;
                return ChoiceChip(
                  label: Text(unit.localizedName(context.l10n)),
                  selected: isSelected,
                  onSelected: (_) => onChanged(unit),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }
}
