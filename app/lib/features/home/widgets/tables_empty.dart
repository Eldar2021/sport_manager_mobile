import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TablesEmpty extends StatelessWidget {
  const TablesEmpty(this.venue, {super.key});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.modal),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Icon(
                Icons.table_restaurant_outlined,
                color: context.colors.primary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            context.l10n.homeTablesEmpty,
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.homeTablesEmptySub,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x14),
            child: FilledButton(
              onPressed: () => context.push(
                AppRoutes.tableForm,
                extra: TableFormExtra(venueId: venue.id),
              ),
              child: Text(context.l10n.homeAddTable),
            ),
          ),
        ],
      ),
    );
  }
}
