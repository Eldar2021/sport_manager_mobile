import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Loading placeholder for the spot-detail body.
class SpotReportDetailSkeleton extends StatelessWidget {
  const SpotReportDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 24),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 96),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 200),
      ],
    );
  }
}
