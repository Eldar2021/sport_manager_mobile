import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class OccupiedSpotFooter extends StatelessWidget {
  const OccupiedSpotFooter({
    required this.sessionCubit,
    required this.onStopPressed,
    super.key,
  });

  final SessionActiveCubit sessionCubit;
  final VoidCallback onStopPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionActiveCubit, SessionActiveState>(
      bloc: sessionCubit,
      builder: (context, state) {
        final isPaused = state.session.isPaused;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: isPaused ? sessionCubit.resumeSession : sessionCubit.pauseSession,
                icon: Icon(isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded),
                style: FilledButton.styleFrom(
                  backgroundColor: isPaused ? context.appColors.success : context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                  minimumSize: const Size(double.infinity, AppSpacing.x16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonBorderRadius,
                  ),
                ),
                label: Text(isPaused ? context.l10n.spotDetailResume : context.l10n.spotDetailPause),
              ),
              const SizedBox(height: AppSpacing.x3),
              FilledButton(
                onPressed: isPaused ? null : onStopPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.error,
                  foregroundColor: context.colors.onError,
                  minimumSize: const Size(double.infinity, AppSpacing.x16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonBorderRadius,
                  ),
                ),
                child: state.stopStatus.isLoading ? const AppActivityIndicator() : Text(context.l10n.spotDetailStop),
              ),
            ],
          ),
        );
      },
    );
  }
}
