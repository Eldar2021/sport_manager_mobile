import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductsListSkeleton extends StatelessWidget {
  const ProductsListSkeleton({this.itemCount = 7, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x2,
        AppSpacing.x4,
        kAppButtonFabClearance,
      ),
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                itemCount,
                (_) => const _ProductSkeletonTile(),
              ),
            ).toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class _ProductSkeletonTile extends StatelessWidget {
  const _ProductSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          ShimmerBox(
            width: 52,
            height: 52,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.6,
                  child: ShimmerBox(height: 14),
                ),
                SizedBox(height: AppSpacing.x2),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.45,
                  child: ShimmerBox(height: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerBox(
                width: AppSpacing.x10,
                height: AppSpacing.x10,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(width: AppSpacing.x2),
              ShimmerBox(
                width: AppSpacing.x10,
                height: AppSpacing.x10,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
