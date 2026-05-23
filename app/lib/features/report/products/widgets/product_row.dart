import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

const List<Color> _kBarColors = [
  Color(0xFFEF4444),
  Color(0xFF6B21A8),
  Color(0xFF3B82F6),
  Color(0xFFF97316),
  Color(0xFFEAB308),
  Color(0xFF8B5CF6),
];

class ProductRow extends StatelessWidget {
  const ProductRow({
    required this.item,
    required this.maxAmount,
    required this.colorIndex,
    required this.venueId,
    super.key,
  });

  final ProductReportItemModel item;
  final int maxAmount;
  final int colorIndex;
  final String venueId;

  @override
  Widget build(BuildContext context) {
    final barColor = _kBarColors[colorIndex % _kBarColors.length];
    final ratio = maxAmount > 0 ? (item.totalAmount / maxAmount).clamp(0.0, 1.0) : 0.0;
    final l10n = context.l10n;
    final amountFormatted = NumberFormat('#,##0', 'ru').format(item.totalAmount);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x2,
      ),
      onTap: () {
        context.push('/reports/venue/$venueId/product/${item.productId}');
      },
      leading: _CategoryIcon(item.category),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: context.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '$amountFormatted ${l10n.currencyLabel}',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          LinearProgressIndicator(
            value: ratio,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            backgroundColor: context.colors.surfaceContainerHighest,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${item.totalCount} ${l10n.productUnitPieceShort}',
            style: context.appTextStyles.muted.labelSmall,
          ),
        ],
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon(this.category);

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: AppRadius.chipBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x2),
        child: Icon(
          category.icon,
          size: 24,
          color: context.colors.onPrimaryContainer,
        ),
      ),
    );
  }
}
