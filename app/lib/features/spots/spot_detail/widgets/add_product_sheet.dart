import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AddProductSheet extends StatefulWidget {
  const AddProductSheet({required this.currency, super.key});

  final String currency;

  static Future<void> show(BuildContext context, {required String currency}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<SessionActiveCubit>(),
        child: AddProductSheet(currency: currency),
      ),
    );
  }

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  late final AddProductSheetCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AddProductSheetCubit(GetIt.I<ProductRepository>());
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => _AddProductSheetBody(
          scrollController: controller,
          currency: widget.currency,
        ),
      ),
    );
  }
}

class _AddProductSheetBody extends StatelessWidget {
  const _AddProductSheetBody({
    required this.scrollController,
    required this.currency,
  });

  final ScrollController scrollController;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.surface,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.x2),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              AppSpacing.x3,
              AppSpacing.x2,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.addProductSheetTitle,
                    style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          _CategoryChips(),
          Expanded(
            child: _ProductGrid(scrollController: scrollController, currency: currency),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
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
              for (final cat in ProductCategory.values)
                ChoiceChip(
                  label: Text(cat.localizedName(context.l10n)),
                  selected: state.selectedCategory == cat,
                  showCheckmark: false,
                  onSelected: (_) => cubit.selectCategory(cat),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.scrollController, required this.currency});

  final ScrollController scrollController;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductSheetCubit, AddProductSheetState>(
      buildWhen: (a, b) => a.products != b.products,
      builder: (_, state) {
        if (state.products.isLoading || state.products is DataInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.products.isFailure) {
          final err = (state.products as DataFailure<List<ProductModel>>).exception;
          return Center(
            child: Text(err.toString(), style: TextStyle(color: context.colors.error)),
          );
        }
        final items = state.items;
        if (items.isEmpty) {
          return Center(child: Text(context.l10n.productsEmptyTitle));
        }
        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x4,
            AppSpacing.x2,
            AppSpacing.x4,
            AppSpacing.x4,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio: 0.85,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => AddProductGridItem(
            items[i],
            currency: currency,
            onTap: () => _showQuantityDialog(context, items[i]),
          ),
        );
      },
    );
  }

  void _showQuantityDialog(BuildContext context, ProductModel product) {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<SessionActiveCubit>(),
        child: _QuantityDialog(product: product, currency: currency),
      ),
    );
  }
}

class _QuantityDialog extends StatefulWidget {
  const _QuantityDialog({required this.product, required this.currency});

  final ProductModel product;
  final String currency;

  @override
  State<_QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<_QuantityDialog> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final unitShort = widget.product.unit.localizedShortName(context.l10n);
    final total = widget.product.price * _quantity;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ProductIconBox(product: widget.product),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${widget.product.price} ${widget.currency.toLowerCase()} / $unitShort',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.addProductQuantityLabel,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Row(
              children: [
                _StepButton(
                  icon: Icons.remove,
                  onTap: _quantity > 1 ? () => setState(() => _quantity--) : null,
                ),
                Expanded(
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$_quantity ',
                            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: unitShort,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _StepButton(
                  icon: Icons.add,
                  onTap: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.appColors.warningContainer,
                borderRadius: AppRadius.buttonBorderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4,
                  vertical: AppSpacing.x3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.addProductTotalLabel,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colors.primary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$total ${widget.currency.toLowerCase()}',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text(context.l10n.cancel),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: BlocBuilder<SessionActiveCubit, SessionActiveState>(
                    buildWhen: (a, b) => a.addProductStatus != b.addProductStatus,
                    builder: (context, state) {
                      return FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: context.appColors.success,
                          foregroundColor: context.appColors.onSuccess,
                        ),
                        onPressed: state.addProductStatus.isLoading ? null : () => _confirm(context),
                        child: state.addProductStatus.isLoading
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(context.l10n.addProductConfirm),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    final cubit = context.read<SessionActiveCubit>();
    Navigator.of(context)
      ..pop()
      ..pop();
    cubit.addProductItem(widget.product.id, quantity: _quantity);
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.outline),
          borderRadius: AppRadius.buttonBorderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x2),
          child: Icon(
            icon,
            size: 24,
            color: onTap == null ? context.colors.onSurfaceVariant : context.colors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ProductIconBox extends StatelessWidget {
  const _ProductIconBox({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    if (product.icon != null && product.icon!.isNotEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.x2),
        ),
        child: Center(
          child: Text(product.icon!, style: const TextStyle(fontSize: 26)),
        ),
      );
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.x2),
      ),
      child: Icon(product.category.icon, size: 24, color: context.colors.onSurfaceVariant),
    );
  }
}
