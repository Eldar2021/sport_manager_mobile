import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Loading placeholder for the tables section — three shimmer rows.
class TablesSkeleton extends StatelessWidget {
  const TablesSkeleton({super.key});

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
