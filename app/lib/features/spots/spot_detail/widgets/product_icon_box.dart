import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductIconBox extends StatelessWidget {
  const ProductIconBox(
    this.product, {
    this.size = 44,
    super.key,
  });

  final ProductModel product;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.x2),
        ),
        child: Center(child: _child(context)),
      ),
    );
  }

  Widget _child(BuildContext context) {
    final photoUrl = product.photoUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.x2),
        child: Image.network(
          photoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    final icon = product.icon;
    if (icon != null && icon.isNotEmpty) {
      return Text(
        icon,
        style: TextStyle(fontSize: size * 0.55),
      );
    }
    return Icon(
      product.category.icon,
      size: size * 0.5,
      color: context.colors.onSurfaceVariant,
    );
  }
}
