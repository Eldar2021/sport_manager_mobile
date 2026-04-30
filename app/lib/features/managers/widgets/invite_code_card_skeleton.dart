import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

const double _shimmerOverlineWidth = 0.45;
const double _shimmerCodeWidth = 0.6;

class InviteCodeCardSkeleton extends StatelessWidget {
  const InviteCodeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _shimmerOverlineWidth,
              child: ShimmerBox(height: AppSpacing.x3),
            ),
            SizedBox(height: AppSpacing.x3),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _shimmerCodeWidth,
              child: ShimmerBox(height: AppSpacing.x8),
            ),
            SizedBox(height: AppSpacing.x4),
            ShimmerBox(height: AppSpacing.x10),
          ],
        ),
      ),
    );
  }
}
