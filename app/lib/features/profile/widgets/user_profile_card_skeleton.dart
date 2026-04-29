import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class UserProfileCardSkeleton extends StatelessWidget {
  const UserProfileCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.surface,
      margin: EdgeInsets.zero,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            ShimmerBox(
              height: AppSpacing.x14,
              width: AppSpacing.x14,
              shape: BoxShape.circle,
            ),
            SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: AppSpacing.x4, width: 160),
                  SizedBox(height: AppSpacing.x2),
                  ShimmerBox(height: AppSpacing.x4, width: 96),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
