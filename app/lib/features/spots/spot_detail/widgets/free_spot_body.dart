import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class FreeSpotBody extends StatelessWidget {
  const FreeSpotBody(this.spot, {required this.venueType, super.key});

  final SpotModel spot;
  final VenueType venueType;

  @override
  Widget build(BuildContext context) {
    final name = spot.name ?? context.l10n.homeSpotTitle(venueType.spotLabel(context), spot.number);
    final tag = spot.description;
    final currency = spot.currency.localizedName(context.l10n);
    final unit = spot.tarifType.localizedUnit(context.l10n).toLowerCase();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x5),
      children: [
        RoleBadge(
          label: context.l10n.homeSpotFree,
          color: context.appColors.success,
          icon: Icons.circle,
        ),
        const SizedBox(height: AppSpacing.x5),
        const AppLogo(),
        const SizedBox(height: AppSpacing.x5),
        Text(
          name,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        if (tag != null && tag.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            '« $tag »',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.x4),
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              TextSpan(
                text: '${spot.tarifAmount}',
                style: context.textTheme.displayMedium?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: ' $currency / $unit',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
      ],
    );
  }
}
