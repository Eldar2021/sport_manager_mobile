import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueListTile extends StatelessWidget {
  const VenueListTile({
    required this.venue,
    required this.onTap,
    super.key,
  });

  final VenueModel venue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      dense: true,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            Icons.location_on_outlined,
            color: context.colors.primary,
            size: 20,
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            venue.name,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.colors.onSurfaceVariant,
            size: 18,
          ),
        ],
      ),
      subtitle: Text(
        '№ ${venue.number} · ${l10n.venueTablesCount(venue.tableCount)}',
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
