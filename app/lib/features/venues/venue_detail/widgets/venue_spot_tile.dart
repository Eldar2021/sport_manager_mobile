import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueSpotTile extends StatelessWidget {
  const VenueSpotTile({
    required this.spot,
    required this.venueType,
    required this.onTap,
    super.key,
  });

  final SpotModel spot;
  final VenueType venueType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final description = spot.description;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.x2),
        ),
        child: SizedBox(
          width: AppSpacing.x10,
          height: AppSpacing.x10,
          child: Center(
            child: Text(
              spot.number.toString(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        spot.name ?? l10n.homeSpotTitle(venueType.spotLabel(context), spot.number),
        style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: description != null && description.isNotEmpty
          ? Text(
              '«$description»',
              style: context.appTextStyles.muted.bodySmall,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: AppRadius.chipBorderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x1,
              ),
              child: Text(
                '${spot.tarifAmount} ${spot.currency.localizedName(l10n)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Icon(
            Icons.arrow_forward_ios,
            size: AppSpacing.x4,
            color: context.colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
