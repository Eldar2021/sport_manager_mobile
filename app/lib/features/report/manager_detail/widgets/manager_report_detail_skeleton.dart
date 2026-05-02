import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Loading placeholder for the manager-detail body. Mirrors the eventual
/// layout (header, KPI band, risk score panel, fraud signals) so the
/// transition to loaded data has minimal layout shift.
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
        ShimmerBox(height: 140),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 80),
      ],
    );
  }
}
