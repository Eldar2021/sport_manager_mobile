import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Loading placeholder for the top-tables section — three shimmer rows.
class TopTablesSkeleton extends StatelessWidget {
  const TopTablesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.x3),
        child: Column(
          children: [
            ShimmerBox(height: 16),
            SizedBox(height: AppSpacing.x2),
            ShimmerBox(height: 16),
            SizedBox(height: AppSpacing.x2),
            ShimmerBox(height: 16),
          ],
        ),
      ),
    );
  }
}
