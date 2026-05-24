import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductsTopSkeleton extends StatelessWidget {
  const ProductsTopSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.x3),
        child: Column(
          children: [
            ShimmerBox(height: 18),
            SizedBox(height: AppSpacing.x3),
            ShimmerBox(height: 18),
            SizedBox(height: AppSpacing.x3),
            ShimmerBox(height: 18),
          ],
        ),
      ),
    );
  }
}
