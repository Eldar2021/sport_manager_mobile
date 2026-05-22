import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductPreviewCard extends StatelessWidget {
  const ProductPreviewCard({
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
    required this.icon,
    required this.photoUrl,
    super.key,
  });

  final String name;
  final ProductCategory category;
  final ProductUnit unit;
  final String price;
  final String? icon;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x2,
        ),
        minVerticalPadding: 0,
        leading: _PreviewThumbnail(
          photoUrl: photoUrl,
          icon: icon,
          category: category,
        ),
        title: Text(
          name.isEmpty ? context.l10n.productsNameHint : name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: name.isEmpty ? context.colors.onSurfaceVariant : null,
          ),
        ),
        subtitle: Text(
          category.localizedName(context.l10n).toUpperCase(),
          style: context.appTextStyles.muted.labelSmall,
        ),
        trailing: _PriceBadge(price: price, unit: unit),
      ),
    );
  }
}

class _PreviewThumbnail extends StatelessWidget {
  const _PreviewThumbnail({
    required this.photoUrl,
    required this.icon,
    required this.category,
  });

  final String? photoUrl;
  final String? icon;
  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 52,
        height: 52,
        child: switch ((photoUrl, icon)) {
          (final url?, _) => Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(context),
          ),
          (null, final emoji?) => ColoredBox(
            color: context.colors.primaryContainer,
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          _ => _fallback(context),
        },
      ),
    );
  }

  Widget _fallback(BuildContext context) => ColoredBox(
    color: context.colors.primaryContainer,
    child: Center(
      child: Icon(category.icon, size: 26, color: context.colors.primary),
    ),
  );
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.price, required this.unit});

  final String price;
  final ProductUnit unit;

  @override
  Widget build(BuildContext context) {
    final unitShort = unit.localizedShortName(context.l10n);
    final priceText = price.isEmpty ? '—' : price;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.x4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          '$priceText ${context.l10n.currencyLabel}/$unitShort',
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
