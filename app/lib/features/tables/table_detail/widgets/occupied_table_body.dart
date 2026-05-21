import 'package:facility/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class OccupiedTableBody extends StatelessWidget {
  const OccupiedTableBody({
    required this.onMistakeLaunch,
    required this.currency,
    super.key,
  });

  final VoidCallback onMistakeLaunch;
  final String currency;

  String _statusLabel(BuildContext context, SessionModel session) {
    final name = session.customerName;
    if (session.isPaused) {
      return name != null && name.isNotEmpty
          ? context.l10n.homeTablePaused(name)
          : context.l10n.homeTablePausedBase;
    }
    return name != null && name.isNotEmpty
        ? context.l10n.homeTableOccupied(name)
        : context.l10n.homeTableOccupiedBase;
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
          context.l10n.tableDetailElapsed,
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
          context.l10n.tableDetailCurrentAmount,
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
          child: AppOutlinedButton(
            title: context.l10n.tableDetailMistakeLaunch,
            icon: Icons.cancel_outlined,
            onTap: onMistakeLaunch,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
      ],
    );
  }
}
