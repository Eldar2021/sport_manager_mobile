import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class HomeSuccess extends StatelessWidget {
  const HomeSuccess({
    required this.venue,
    required this.spots,
    required this.onSpotTap,
    super.key,
  });

  final VenueModel venue;
  final List<SpotModel> spots;
  final void Function(SpotModel) onSpotTap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x4,
            AppSpacing.x4,
            AppSpacing.x4,
            AppSpacing.x2,
          ),
          sliver: SliverToBoxAdapter(
            child: Text(
              context.l10n.homeSpotsSection(venue.type.spotLabelPlural(context).toUpperCase(), spots.length),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.x3,
              crossAxisSpacing: AppSpacing.x3,
              childAspectRatio: 1.2,
            ),
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              return SpotCard(
                key: ValueKey(spot.id),
                spot,
                venueType: venue.type,
                onTap: () => onSpotTap(spot),
              );
            },
          ),
        ),
      ],
    );
  }
}
