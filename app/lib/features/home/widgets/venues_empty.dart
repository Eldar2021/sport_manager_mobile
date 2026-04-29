import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenuesEmpty extends StatelessWidget {
  const VenuesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Icon(
                Icons.location_on_outlined,
                color: context.colors.primary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Text(
            context.l10n.homeNoVenuesTitle,
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.homeNoVenuesSubtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x14),
            child: FilledButton(
              onPressed: () => context.push(AppRoutes.venueForm),
              child: Text(context.l10n.homeCreateVenue),
            ),
          ),
        ],
      ),
    );
  }
}
