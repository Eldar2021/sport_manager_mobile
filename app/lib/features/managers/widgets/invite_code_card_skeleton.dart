import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class InviteCodeCardSkeleton extends StatelessWidget {
  const InviteCodeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.primaryContainer.withValues(alpha: 0.6),
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShimmerBox(height: AppSpacing.x3, width: 160),
            SizedBox(height: AppSpacing.x3),
            ShimmerBox(height: AppSpacing.x8, width: 200),
            SizedBox(height: AppSpacing.x4),
            ShimmerBox(height: AppSpacing.x10),
          ],
        ),
      ),
    );
  }
}
