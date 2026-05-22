import 'package:flutter/material.dart';
import 'package:product/product.dart';
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
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: context.colors.primary.withValues(
          alpha: AppOpacity.tint,
        ),
        child: Icon(
          product.category.icon,
          color: context.colors.primary,
          size: 20,
        ),
      ),
      title: Text(
        product.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${product.price} ${context.l10n.currencyLabel}',
        style: context.appTextStyles.muted.bodySmall,
      ),
      trailing: isDeleting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : PopupMenuButton<_Action>(
              onSelected: (action) {
                if (action == _Action.edit) onEdit();
                if (action == _Action.delete) onDelete();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: _Action.edit,
                  child: Text(context.l10n.menuEdit),
                ),
                PopupMenuItem(
                  value: _Action.delete,
                  child: Text(
                    context.l10n.menuDelete,
                    style: TextStyle(color: context.colors.error),
                  ),
                ),
              ],
            ),
    );
  }
}

enum _Action { edit, delete }
