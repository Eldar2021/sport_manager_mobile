import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductTile extends StatelessWidget {
  const ProductTile(
    this.product, {
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final ProductModel product;
  final bool isDeleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final unitShort = product.unit.localizedShortName(context.l10n);
    final subtitle = '${product.price} ${context.l10n.currencyLabel} / $unitShort';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      minVerticalPadding: 0,
      leading: _ProductThumbnail(product),
      title: Text(
        product.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.appTextStyles.muted.bodySmall,
      ),
      trailing: isDeleting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.x2,
              children: [
                _ActionButton(
                  icon: Icons.edit_outlined,
                  color: context.colors.primary,
                  backgroundColor: context.colors.primary.withValues(alpha: 0.12),
                  onTap: onEdit,
                ),
                _ActionButton(
                  icon: Icons.delete_outline,
                  color: context.colors.error,
                  backgroundColor: context.colors.error.withValues(alpha: 0.1),
                  onTap: onDelete,
                ),
              ],
            ),
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail(this.product);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final url = product.photoUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 52,
        height: 52,
        child: url != null
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return _IconFallback(product.category);
                },
              )
            : _IconFallback(product.category),
      ),
    );
  }
}

class _IconFallback extends StatelessWidget {
  const _IconFallback(this.category);

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.primaryContainer,
      child: Center(
        child: Icon(
          category.icon,
          size: 26,
          color: context.colors.primary,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: color,
        size: 20,
      ),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: const Size(40, 40),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
