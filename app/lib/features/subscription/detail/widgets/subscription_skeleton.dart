import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SubscriptionSkeleton extends StatelessWidget {
  const SubscriptionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: const [
        ShimmerBox(height: 160, borderRadius: AppRadius.cardBorderRadius),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 140, borderRadius: AppRadius.cardBorderRadius),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 100, borderRadius: AppRadius.cardBorderRadius),
      ],
    );
  }
}
