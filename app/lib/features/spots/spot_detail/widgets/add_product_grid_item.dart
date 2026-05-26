import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
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
      child: Card(
        color: context.colors.surface,
        surfaceTintColor: context.colors.surface,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardBorderRadius,
          side: BorderSide(
            color: context.colors.outlineVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductIconBox(
                product,
                size: 56,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                product.name,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${product.price} ',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: '${currency.toLowerCase()}/$unitShort',
                      style: context.textTheme.bodyMedium?.copyWith(
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
