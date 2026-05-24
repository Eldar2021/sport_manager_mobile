import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductsBreakdown extends StatelessWidget {
  const ProductsBreakdown(this.currency, {super.key});

  final String currency;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionActiveCubit, SessionActiveState, (List<SessionProductItemModel>, int, int)>(
      selector: (s) => (s.session.products, s.session.productsAmount, s.currentAmount),
      builder: (context, data) {
        final (products, productsAmount, subtotal) = data;
        if (products.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.paymentProductsSection(products.length),
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            for (final item in products)
              _PaymentProductRow(
                item: item,
                currency: currency,
              ),
            const SizedBox(height: AppSpacing.x2),
            Divider(
              color: context.colors.outline,
              height: 1,
            ),
            const SizedBox(height: AppSpacing.x2),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x2,
              ),
              child: SpotInfoRow(
                label: context.l10n.paymentProductsTotal,
                value: '$productsAmount $currency',
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Divider(
              color: context.colors.outline,
              height: 1,
            ),
            const SizedBox(height: AppSpacing.x2),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x2,
              ),
              child: SpotInfoRow(
                label: context.l10n.paymentSubtotalLine,
                value: '$subtotal $currency',
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
          ],
        );
      },
    );
  }
}

class _PaymentProductRow extends StatelessWidget {
  const _PaymentProductRow({
    required this.item,
    required this.currency,
  });

  final SessionProductItemModel item;
  final String currency;

  String _unitShort(AppLocalizations l10n) {
    return switch (item.unitSnapshot) {
      'KG' => l10n.productUnitKgShort,
      'LITRE' => l10n.productUnitLitreShort,
      'PORTION' => l10n.productUnitPortionShort,
      'HOUR' => l10n.productUnitHourShort,
      _ => l10n.productUnitPieceShort,
    };
  }

  @override
  Widget build(BuildContext context) {
    final unitShort = _unitShort(context.l10n);
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: _PaymentProductIcon(item.categorySnapshot),
      title: Text(
        item.nameSnapshot,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '1 $unitShort × ${item.priceSnapshot} $currency',
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        '${item.priceSnapshot} $currency',
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PaymentProductIcon extends StatelessWidget {
  const _PaymentProductIcon(this.categorySnapshot);

  final String categorySnapshot;

  @override
  Widget build(BuildContext context) {
    final icon = switch (categorySnapshot) {
      'DRINK' => Icons.local_drink_outlined,
      'FOOD' => Icons.restaurant_outlined,
      'EQUIPMENT' => Icons.sports_tennis_outlined,
      _ => Icons.shopping_bag_outlined,
    };
    return SizedBox(
      width: 32,
      height: 32,
      child: ColoredBox(
        color: context.colors.surface,
        child: Icon(
          icon,
          size: 16,
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
