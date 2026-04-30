import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueCardSkeleton extends StatelessWidget {
  const VenueCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ShimmerBox(
                  height: AppSpacing.x10,
                  width: AppSpacing.x10,
                  borderRadius: AppRadius.buttonBorderRadius,
                ),
                SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(height: AppSpacing.x4, width: 160),
                      SizedBox(height: AppSpacing.x2),
                      ShimmerBox(height: AppSpacing.x3, width: 120),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.x4),
            ShimmerBox(
              height: AppSpacing.x12,
              borderRadius: AppRadius.buttonBorderRadius,
            ),
          ],
        ),
      ),
    );
  }
}
