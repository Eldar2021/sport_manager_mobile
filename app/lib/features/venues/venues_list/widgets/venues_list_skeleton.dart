import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenuesListSkeleton extends StatelessWidget {
  const VenuesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.x4),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x3),
      itemBuilder: (_, _) => const VenueCardSkeleton(),
    );
  }
}
