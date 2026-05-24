import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SessionProductsList extends StatelessWidget {
  const SessionProductsList({
    required this.currency,
    required this.onAddProduct,
    super.key,
  });

  final String currency;
  final VoidCallback onAddProduct;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionActiveCubit, SessionActiveState, List<SessionProductItemModel>>(
      selector: (s) => s.session.products,
      builder: (context, products) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  products.isEmpty
                      ? context.l10n.sessionOrderSectionLabel
                      : context.l10n.sessionOrderSection(products.length),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                IntrinsicWidth(
                  child: FilledButton.icon(
                    onPressed: onAddProduct,
                    icon: const Icon(Icons.add, size: 16),
                    label: Text(context.l10n.sessionAddProduct),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x3,
                        vertical: AppSpacing.x2,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: context.textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            if (products.isEmpty)
              _EmptyOrderCard()
            else
              _ProductsCard(
                products: products,
                currency: currency,
              ),
          ],
        );
      },
    );
  }
}

class _EmptyOrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.outlineVariant,
        ),
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: context.colors.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                context.l10n.sessionOrderEmpty,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsCard extends StatelessWidget {
  const _ProductsCard({
    required this.products,
    required this.currency,
  });

  final List<SessionProductItemModel> products;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SessionActiveCubit>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.cardBorderRadius,
        boxShadow: context.appColors.shadowSm,
      ),
      child: Column(
        children: [
          for (int i = 0; i < products.length; i++) ...[
            if (i > 0)
              Divider(
                color: context.colors.outlineVariant,
                height: 1,
                indent: AppSpacing.x4,
              ),
            SessionProductItemTile(
              products[i],
              currency: currency,
              onRemove: () => _confirmRemove(context, cubit, products[i]),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmRemove(
    BuildContext context,
    SessionActiveCubit cubit,
    SessionProductItemModel item,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.sessionRemoveProductTitle),
          content: Text(context.l10n.sessionRemoveProductSubtitle),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cubit.removeProductItem(item.id);
              },
              child: Text(
                context.l10n.sessionRemoveProductConfirm,
                style: TextStyle(color: context.colors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
