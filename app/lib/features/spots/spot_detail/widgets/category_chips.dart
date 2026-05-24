import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddProductSheetCubit>();
    return BlocBuilder<AddProductSheetCubit, AddProductSheetState>(
      buildWhen: (a, b) => a.selectedCategory != b.selectedCategory,
      builder: (_, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            spacing: AppSpacing.x2,
            children: [
              ChoiceChip(
                label: Text(context.l10n.productsFilterAll),
                selected: state.selectedCategory == null,
                showCheckmark: false,
                onSelected: (_) => cubit.selectCategory(null),
              ),
              ...ProductCategory.values.map(
                (cat) {
                  return ChoiceChip(
                    label: Text(cat.localizedName(context.l10n)),
                    selected: state.selectedCategory == cat,
                    showCheckmark: false,
                    onSelected: (_) => cubit.selectCategory(cat),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
