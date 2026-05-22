import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SpotCard extends StatelessWidget {
  const SpotCard(this.spot, {required this.venueType, this.onTap, super.key});

  final SpotModel spot;
  final VenueType venueType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final occupied = spot.isOccupied;
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: occupied ? context.colors.error.withValues(alpha: 0.06) : context.colors.surface,
          borderRadius: AppRadius.cardBorderRadius,
          border: Border.all(
            color: occupied ? context.colors.error : context.colors.outline,
            width: occupied ? 1.5 : 1.0,
          ),
          boxShadow: occupied ? null : context.appColors.shadowSm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpotCardTitle(spot, venueType: venueType),
              const Spacer(),
              SpotCardFooter(spot),
            ],
          ),
        ),
      ),
    );
  }
}
