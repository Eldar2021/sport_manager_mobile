import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProfileSectionSkeletonTile extends StatelessWidget {
  const ProfileSectionSkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: ShimmerBox(
        height: AppSpacing.x10,
        width: AppSpacing.x10,
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.x2)),
      ),
      title: Padding(
        padding: EdgeInsets.only(right: AppSpacing.x12),
        child: ShimmerBox(height: AppSpacing.x4, width: 140),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: AppSpacing.x2, right: AppSpacing.x16),
        child: ShimmerBox(height: AppSpacing.x3, width: 96),
      ),
    );
  }
}
