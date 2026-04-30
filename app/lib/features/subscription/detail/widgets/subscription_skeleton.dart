import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SubscriptionSkeleton extends StatelessWidget {
  const SubscriptionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(
          height: 160,
          borderRadius: AppRadius.cardBorderRadius,
        ),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(
          height: 140,
          borderRadius: AppRadius.cardBorderRadius,
        ),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(
          height: 100,
          borderRadius: AppRadius.cardBorderRadius,
        ),
      ],
    );
  }
}
