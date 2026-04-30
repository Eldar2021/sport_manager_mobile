import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
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
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(venue: venue),
              const SizedBox(height: AppSpacing.x4),
              _MetricTile(
                label: context.l10n.venueMetricTablesLabel,
                value: '${venue.tableCount}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              Icons.location_on_outlined,
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
        const SizedBox(width: AppSpacing.x2),
        Icon(
          Icons.arrow_forward_ios,
          size: AppSpacing.x4,
          color: context.colors.onSurfaceVariant,
        ),
      ],
    );
  }

  String _subtitle(VenueModel venue) {
    final number = '№ ${venue.number}';
    final address = venue.address;
    if (address == null || address.isEmpty) return number;
    return '$number · $address';
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: AppRadius.buttonBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
