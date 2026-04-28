import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class HomeVenueBar extends StatelessWidget {
  const HomeVenueBar({
    required this.venue,
    required this.tableCount,
    required this.onTap,
    super.key,
  });

  final VenueModel venue;
  final int tableCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4, vertical: AppSpacing.x1),
        leading: SizedBox(
          width: 44,
          height: 44,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(Icons.location_on_outlined, color: context.colors.primary, size: 24),
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
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, color: context.colors.onSurfaceVariant, size: 18),
          ],
        ),
        subtitle: Text(
          '№ ${venue.number}',
          style: context.textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
        ),
      ),
    );
  }
}
