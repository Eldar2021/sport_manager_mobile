import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 80),
        SizedBox(height: AppSpacing.x3),
        ShimmerBox(height: 96),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 180),
      ],
    );
  }
}
