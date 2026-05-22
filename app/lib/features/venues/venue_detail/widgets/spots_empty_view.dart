import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SpotsEmptyView extends StatelessWidget {
  const SpotsEmptyView({required this.venueType, super.key});

  final VenueType venueType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            venueType.icon,
            color: context.colors.onSurfaceVariant,
            size: AppSpacing.x10,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            context.l10n.homeSpotsEmpty(venueType.spotLabelPlural(context)),
            style: context.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x1),
          BlocSelector<AuthCubit, AuthState, bool>(
            selector: (state) => state.isManager,
            builder: (context, isManager) => Text(
              isManager
                  ? context.l10n.homeSpotsEmptySubManager(venueType.spotLabelPlural(context))
                  : context.l10n.homeSpotsEmptySub(venueType.spotLabel(context)),
              style: context.appTextStyles.muted.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
