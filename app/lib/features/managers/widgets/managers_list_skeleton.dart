import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ManagersListSkeleton extends StatelessWidget {
  const ManagersListSkeleton({
    this.itemCount = 3,
    super.key,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemCount,
        (i) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (i != 0) const Divider(height: 1),
            const _ManagerSkeletonTile(),
          ],
        ),
      ),
    );
  }
}

class _ManagerSkeletonTile extends StatelessWidget {
  const _ManagerSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x1,
      ),
      leading: ShimmerBox(
        height: AppSpacing.x12,
        width: AppSpacing.x12,
        shape: BoxShape.circle,
      ),
      title: Padding(
        padding: EdgeInsets.only(right: AppSpacing.x16),
        child: ShimmerBox(height: AppSpacing.x4, width: 140),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(
          top: AppSpacing.x2,
          right: AppSpacing.x16,
        ),
        child: ShimmerBox(height: AppSpacing.x3, width: 100),
      ),
    );
  }
}
