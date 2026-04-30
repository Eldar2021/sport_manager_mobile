import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';

class VenueDetailSkeleton extends StatelessWidget {
  const VenueDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: 5,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, _) => const VenueTableTileSkeleton(),
    );
  }
}
