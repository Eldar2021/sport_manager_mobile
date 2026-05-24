import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AddProductGridItem extends StatelessWidget {
  const AddProductGridItem(
    this.product, {
    required this.currency,
    required this.onTap,
    super.key,
  });

  final ProductModel product;
  final String currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unitShort = product.unit.localizedShortName(context.l10n);
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.cardBorderRadius,
          border: Border.all(
            color: context.colors.outlineVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductIconBox(product),
              const SizedBox(height: AppSpacing.x2),
              Text(
                product.name,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.x1),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${product.price} ',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: '${currency.toLowerCase()}/$unitShort',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductIconBox extends StatelessWidget {
  const _ProductIconBox(this.product);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    if (product.icon != null && product.icon!.isNotEmpty) {
      return SizedBox(
        width: 44,
        height: 44,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.x2),
          ),
          child: Center(
            child: Text(
              product.icon!,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      );
    }
    final icon = product.category.icon;
    return SizedBox(
      width: 44,
      height: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.x2),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 22,
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
