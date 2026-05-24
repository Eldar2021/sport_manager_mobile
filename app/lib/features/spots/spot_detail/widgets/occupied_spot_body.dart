import 'package:facility/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class OccupiedSpotBody extends StatelessWidget {
  const OccupiedSpotBody({
    required this.onMistakeLaunch,
    required this.onAddProduct,
    required this.currency,
    super.key,
  });

  final VoidCallback onMistakeLaunch;
  final VoidCallback onAddProduct;
  final String currency;

  String _statusLabel(BuildContext context, SessionModel session) {
    final name = session.customerName;
    if (session.isPaused) {
      return name != null && name.isNotEmpty ? context.l10n.homeSpotPaused(name) : context.l10n.homeSpotPausedBase;
    }
    return name != null && name.isNotEmpty ? context.l10n.homeSpotOccupied(name) : context.l10n.homeSpotOccupiedBase;
  }

  @override
  Widget build(BuildContext context) {
    final session = context.select<SessionActiveCubit, SessionModel>(
      (cubit) => cubit.state.session,
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x5),
      children: [
        RoleBadge(
          label: _statusLabel(context, session),
          color: session.isPaused ? context.colors.primary : context.colors.error,
          icon: Icons.circle,
        ),
        const SizedBox(height: AppSpacing.x5),
        const ElapsedTimer(),
        const SizedBox(height: AppSpacing.x1),
        Text(
          context.l10n.spotDetailElapsed,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.x4),
        BlocSelector<SessionActiveCubit, SessionActiveState, int>(
          selector: (state) => state.currentAmount,
          builder: (context, amount) {
            return Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(
                    text: '$amount',
                    style: context.textTheme.displayMedium?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: ' $currency',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          context.l10n.spotDetailCurrentAmount,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.x5),
        BlocSelector<SessionActiveCubit, SessionActiveState, int>(
          selector: (state) => state.elapsed.inMinutes,
          builder: (context, elapsedMinutes) {
            return SessionInfoCard(
              session: session,
              elapsed: Duration(minutes: elapsedMinutes),
              currency: currency,
            );
          },
        ),

        const SizedBox(height: AppSpacing.x4),
        SessionProductsList(
          currency: currency,
          onAddProduct: onAddProduct,
        ),
        const SizedBox(height: AppSpacing.x4),
        IntrinsicWidth(
          child: FilledButton.icon(
            onPressed: onMistakeLaunch,
            icon: const Icon(Icons.cancel_outlined, size: 16),
            label: Text(context.l10n.spotDetailMistakeLaunch),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: context.textTheme.labelMedium,
            ),
          ),
        ),
        const SizedBox(height: kAppButtonFabClearance),
      ],
    );
  }
}
