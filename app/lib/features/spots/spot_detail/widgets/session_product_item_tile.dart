import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SessionProductItemTile extends StatelessWidget {
  const SessionProductItemTile(
    this.item, {
    required this.currency,
    required this.onRemove,
    super.key,
  });

  final SessionProductItemModel item;
  final String currency;
  final VoidCallback onRemove;

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
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
      ),
      leading: _ProductIcon(item.categorySnapshot),
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${item.priceSnapshot}',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductIcon extends StatelessWidget {
  const _ProductIcon(this.categorySnapshot);

  final String categorySnapshot;

  @override
  Widget build(BuildContext context) {
    final icon = switch (categorySnapshot) {
      'DRINK' => Icons.local_drink_outlined,
      'FOOD' => Icons.restaurant_outlined,
      'EQUIPMENT' => Icons.sports_tennis_outlined,
      _ => Icons.shopping_bag_outlined,
    };
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.x2),
      ),
      child: Icon(
        icon,
        size: 20,
        color: context.colors.onSurfaceVariant,
      ),
    );
  }
}
