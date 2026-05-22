import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({
    required this.venue,
    required this.onTap,
    super.key,
  });

  final VenueModel venue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        leading: DecoratedBox(
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
        title: Text(venue.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.x1),
            Text(_subtitle(venue)),
            const SizedBox(height: AppSpacing.x2),
            Row(
              children: [
                Text(
                  venue.type.spotLabelPlural(context).toUpperCase(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  '${venue.spotCount}',
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppSpacing.x4,
          color: context.colors.onSurfaceVariant,
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
