import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductsSkeleton extends StatelessWidget {
  const ProductsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.x4),
        child: Column(
          children: [
            ShimmerBox(height: 20),
            SizedBox(height: AppSpacing.x3),
            ShimmerBox(height: 20),
            SizedBox(height: AppSpacing.x3),
            ShimmerBox(height: 20),
            SizedBox(height: AppSpacing.x3),
            ShimmerBox(height: 20),
            SizedBox(height: AppSpacing.x3),
            ShimmerBox(height: 20),
          ],
        ),
      ),
    );
  }
}
