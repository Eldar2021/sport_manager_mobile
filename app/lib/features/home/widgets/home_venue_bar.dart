import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4, vertical: AppSpacing.x1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.brandAmberLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.location_on_outlined, color: AppColors.brandAmber, size: 18),
            ),
            const SizedBox(width: AppSpacing.x2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      venue.name,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink900,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.ink500, size: 18),
                  ],
                ),
                Text(
                  '№ ${venue.number} · ${_numTables(tableCount)}',
                  style: AppTypography.caption.copyWith(color: AppColors.ink500),
                ),
              ],
            ),
          ],
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.x2),
        Container(
          width: 36,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.ink300,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.x5, AppSpacing.x4, AppSpacing.x3, AppSpacing.x2),
          child: Row(
            children: [
              Text(l10n.homeSelectVenue, style: AppTypography.h2),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.ink100,
                  foregroundColor: AppColors.ink700,
                ),
              ),
            ],
          ),
        ),
        ...venues.map(
          (v) => _VenuePickerItem(
            venue: v,
            isSelected: selectedVenue?.id == v.id,
            onTap: () {
              Navigator.pop(context);
              onSelect(v);
            },
          ),
        ),
        if (isOwner)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.x5, AppSpacing.x2, AppSpacing.x5, AppSpacing.x6),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context.push('/venues/create');
              },
              child: Row(
                children: [
                  const Icon(Icons.add_circle_outline_rounded, color: AppColors.brandAmber, size: 20),
                  const SizedBox(width: AppSpacing.x3),
                  Text(
                    l10n.homeNewVenue,
                    style: AppTypography.body.copyWith(
                      color: AppColors.brandAmber,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const SizedBox(height: AppSpacing.x6),
      ],
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5, vertical: AppSpacing.x3),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: AppTypography.body.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.ink900,
                    ),
                  ),
                  Text(
                    '№ ${venue.number}',
                    style: AppTypography.caption.copyWith(color: AppColors.ink500),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_rounded, color: AppColors.brandAmber, size: 20),
          ],
        ),
      ),
    );
  }
}
