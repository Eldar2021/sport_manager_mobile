import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueDetailHeaderCard extends StatelessWidget {
  const VenueDetailHeaderCard({
    required this.venue,
    required this.spotCount,
    super.key,
  });

  final VenueModel venue;
  final int spotCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.primaryContainer,
                    borderRadius: AppRadius.buttonBorderRadius,
                  ),
                  child: SizedBox(
                    width: AppSpacing.x10,
                    height: AppSpacing.x10,
                    child: Icon(
                      venue.type.icon,
                      color: context.colors.primary,
                      size: AppSpacing.x5,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        venue.name,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        _subtitle(venue),
                        style: context.appTextStyles.muted.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surfaceContainer,
                borderRadius: AppRadius.buttonBorderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4,
                ),
                child: Row(
                  children: [
                    Text(
                      venue.type.spotLabelPlural(context).toUpperCase(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$spotCount',
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle(VenueModel venue) {
    final number = '№ ${venue.number}';
    final address = venue.address;
    if (address == null || address.isEmpty) return number;
    return '$number · $address';
  }
}
