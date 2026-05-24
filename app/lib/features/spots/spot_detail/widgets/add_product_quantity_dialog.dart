import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AddProductQuantityDialog extends StatefulWidget {
  const AddProductQuantityDialog({
    required this.product,
    required this.currency,
    super.key,
  });

  final ProductModel product;
  final String currency;

  static void show(
    BuildContext context, {
    required ProductModel product,
    required String currency,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<SessionActiveCubit>(),
        child: AddProductQuantityDialog(
          product: product,
          currency: currency,
        ),
      ),
    );
  }

  @override
  State<AddProductQuantityDialog> createState() => _AddProductQuantityDialogState();
}

class _AddProductQuantityDialogState extends State<AddProductQuantityDialog> {
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ProductIconBox(
                widget.product,
                size: 48,
              ),
              title: Text(
                widget.product.name,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                '${widget.product.price} ${widget.currency.toLowerCase()} / $unitShort',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
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
                IconButton(
                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    side: BorderSide(color: context.colors.outline),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.buttonBorderRadius,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$_quantity ',
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
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
                IconButton(
                  onPressed: () => setState(() => _quantity++),
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    side: BorderSide(color: context.colors.outline),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.buttonBorderRadius,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            ListTile(
              tileColor: context.appColors.warningContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.buttonBorderRadius,
              ),
              title: Text(
                context.l10n.addProductTotalLabel,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colors.primary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(
                '$total ${widget.currency.toLowerCase()}',
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text(
                      context.l10n.cancel,
                      style: context.textTheme.bodyMedium,
                    ),
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
                            : Text(
                                context.l10n.addProductConfirm,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.appColors.onSuccess,
                                ),
                              ),
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
    cubit.addProductItem(
      widget.product.id,
      quantity: _quantity,
    );
  }
}
