import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SpotsEmpty extends StatelessWidget {
  const SpotsEmpty(this.venue, {super.key});

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
                venue.type.icon,
                color: context.colors.primary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            context.l10n.homeSpotsEmpty(venue.type.spotLabelPlural(context)),
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          BlocSelector<AuthCubit, AuthState, bool>(
            selector: (state) => state.isManager,
            builder: (context, isManager) => Text(
              isManager
                  ? context.l10n.homeSpotsEmptySubManager(venue.type.spotLabelPlural(context))
                  : context.l10n.homeSpotsEmptySub(venue.type.spotLabel(context)),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
