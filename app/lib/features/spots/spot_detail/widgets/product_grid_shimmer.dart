import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer(this.scrollController, {super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x2,
        AppSpacing.x4,
        AppSpacing.x4,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        childAspectRatio: 1.2,
      ),
      itemCount: 6,
      itemBuilder: (_, _) {
        return const ShimmerBox(
          height: double.infinity,
          borderRadius: AppRadius.cardBorderRadius,
        );
      },
    );
  }
}
