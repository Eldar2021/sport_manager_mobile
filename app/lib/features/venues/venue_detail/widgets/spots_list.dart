import 'dart:async';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';

class SpotsList extends StatelessWidget {
  const SpotsList({
    required this.spots,
    required this.venueId,
    required this.venueType,
    required this.isOwner,
    required this.onSpotUpdated,
    super.key,
  });

  final List<SpotModel> spots;
  final String venueId;
  final VenueType venueType;
  final bool isOwner;
  final VoidCallback onSpotUpdated;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: spots.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final spot = spots[index];
        return VenueSpotTile(
          key: ValueKey(spot.id),
          spot: spot,
          venueType: venueType,
          onTap: isOwner ? () => _navToSpot(context, spot) : null,
        );
      },
    );
  }

  Future<void> _navToSpot(BuildContext context, SpotModel spot) async {
    final result = await context.push(
      AppRoutes.spotForm,
      extra: SpotFormExtra(venueId: venueId, spot: spot),
    );
    if (result != null) onSpotUpdated();
  }
}
