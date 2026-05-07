import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class CustomSheetShimmer extends StatelessWidget {
  const CustomSheetShimmer({
    required this.controller,
    this.itemCount = 6,
    super.key,
  });

  final ScrollController controller;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        0,
        AppSpacing.x4,
        AppSpacing.x10,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x2),
      itemBuilder: (_, _) => const ShimmerBox(
        height: AppSpacing.x14,
        borderRadius: AppRadius.cardBorderRadius,
      ),
    );
  }
}
