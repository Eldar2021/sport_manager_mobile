import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueSpotTileSkeleton extends StatelessWidget {
  const VenueSpotTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      leading: ShimmerBox(
        height: AppSpacing.x10,
        width: AppSpacing.x10,
        shape: BoxShape.circle,
      ),
      title: Padding(
        padding: EdgeInsets.only(right: AppSpacing.x16),
        child: ShimmerBox(height: AppSpacing.x4, width: 120),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: AppSpacing.x2, right: AppSpacing.x16),
        child: ShimmerBox(height: AppSpacing.x3, width: 96),
      ),
      trailing: ShimmerBox(
        height: AppSpacing.x6,
        width: AppSpacing.x16,
      ),
    );
  }
}
