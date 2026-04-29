import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class UserProfileExtraDataSkeleton extends StatelessWidget {
  const UserProfileExtraDataSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: AppSpacing.x6),
        ShimmerBox(height: AppSpacing.x4, width: 96),
        SizedBox(height: AppSpacing.x2),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileSectionSkeletonTile(),
              Divider(),
              ProfileSectionSkeletonTile(),
            ],
          ),
        ),
      ],
    );
  }
}
