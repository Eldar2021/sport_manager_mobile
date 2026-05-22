import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/product/product.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar(this.cubit, {super.key});

  final ProductsListCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsListCubit, ProductsListState>(
      bloc: cubit,
      buildWhen: (a, b) => a.category != b.category,
      builder: (_, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x4,
            AppSpacing.x3,
            AppSpacing.x4,
            AppSpacing.x3,
          ),
          child: Row(
            spacing: AppSpacing.x2,
            children: [
              ChoiceChip(
                label: Text(context.l10n.productsFilterAll),
                selected: state.category == null,
                showCheckmark: false,
                onSelected: (_) => cubit.load(clearCategory: true),
              ),
              for (final cat in ProductCategory.values)
                ChoiceChip(
                  label: Text(cat.localizedName(context.l10n)),
                  selected: state.category == cat,
                  showCheckmark: false,
                  onSelected: (_) => cubit.load(category: cat),
                ),
            ],
          ),
        );
      },
    );
  }
}
