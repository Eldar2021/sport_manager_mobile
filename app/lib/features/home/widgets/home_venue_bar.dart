import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:venues/venues.dart';

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
          '№ ${venue.number} · ${_numTables(tableCount)}',
          style: context.textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
        ),
      ),
    );
  }

  String _numTables(int n) {
    if (n == 1) return '1 стол';
    if (n >= 2 && n <= 4) return '$n стола';
    return '$n столов';
  }
}

class HomeVenuePicker extends StatelessWidget {
  const HomeVenuePicker({
    required this.venues,
    required this.selectedVenue,
    required this.onSelect,
    this.isOwner = false,
    super.key,
  });

  final List<VenueModel> venues;
  final VenueModel? selectedVenue;
  final ValueChanged<VenueModel> onSelect;
  final bool isOwner;

  static Future<void> show(
    BuildContext context, {
    required List<VenueModel> venues,
    required VenueModel? selectedVenue,
    required ValueChanged<VenueModel> onSelect,
    bool isOwner = false,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => HomeVenuePicker(
        venues: venues,
        selectedVenue: selectedVenue,
        onSelect: onSelect,
        isOwner: isOwner,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(l10n.homeSelectVenue, style: context.textTheme.titleLarge),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: context.colors.surfaceContainerHigh,
                  foregroundColor: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          ...venues.map(
            (v) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
              child: _VenuePickerItem(
                venue: v,
                isSelected: selectedVenue?.id == v.id,
                onTap: () {
                  Navigator.pop(context);
                  onSelect(v);
                },
              ),
            ),
          ),
          if (isOwner) ...[
            const SizedBox(height: AppSpacing.x4),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.venueForm);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: context.colors.surface,
                  foregroundColor: context.colors.onSurfaceVariant,
                  side: BorderSide(color: context.colors.outline, style: BorderStyle.values[1]),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.cardBorderRadius,
                  ),
                ),
                icon: Icon(Icons.add_rounded, color: context.colors.primary),
                label: Text(
                  l10n.homeNewVenue,
                  style: context.textTheme.bodyLarge?.copyWith(color: context.colors.primary),
                ),
              ),
            ),
          ] else
            const SizedBox(height: AppSpacing.x6),
        ],
      ),
    );
  }
}

class _VenuePickerItem extends StatelessWidget {
  const _VenuePickerItem({
    required this.venue,
    required this.isSelected,
    required this.onTap,
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
      leading: SizedBox(
        width: 40,
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? context.colors.primary : context.colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
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
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: context.colors.onSurface,
        ),
      ),
      subtitle: Text(
        '№ ${venue.number}',
        style: context.textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
      ),
      trailing: isSelected ? Icon(Icons.check_rounded, color: context.colors.primary) : null,
    );
  }
}
