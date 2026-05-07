import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueItem extends StatelessWidget {
  const VenueItem({
    required this.venue,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final VenueModel venue;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: isSelected ? context.colors.primaryContainer : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardBorderRadius),
      leading: SizedBox(
        width: 40,
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? context.colors.primary : context.colors.surfaceContainerHigh,
            borderRadius: AppRadius.buttonBorderRadius,
          ),
          child: Center(
            child: Icon(
              Icons.location_on_outlined,
              color: isSelected ? context.colors.onPrimary : context.colors.onSurfaceVariant,
              size: 18,
            ),
          ),
        ),
      ),
      title: Text(
        venue.name,
        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        '№ ${venue.number} · ${context.l10n.venueTablesCount(venue.tableCount)}',
        style: context.appTextStyles.muted.bodySmall,
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_rounded,
              color: context.colors.primary,
            )
          : null,
    );
  }
}
