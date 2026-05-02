import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Loading placeholder for the manager-detail body — header card, KPI
/// band, and a session-log block.
class ManagerReportDetailSkeleton extends StatelessWidget {
  const ManagerReportDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 80),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 96),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 200),
      ],
    );
  }
}
