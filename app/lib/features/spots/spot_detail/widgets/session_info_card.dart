import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SessionInfoCard extends StatelessWidget {
  const SessionInfoCard({
    required this.session,
    required this.elapsed,
    required this.currency,
    super.key,
  });

  final SessionModel session;
  final Duration elapsed;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final tarif = session.tarifAmountSnapshot ?? 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.cardBorderRadius,
        boxShadow: context.appColors.shadowSm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        child: BlocSelector<SessionActiveCubit, SessionActiveState, (int, int)>(
          selector: (s) => (s.timeAmount, s.session.productsAmount),
          builder: (context, data) {
            final (timeAmount, productsAmount) = data;
            return Column(
              children: [
                SpotInfoRow(
                  label: context.l10n.spotDetailStartTime,
                  value: DateFormat('HH:mm').format(session.startedAt),
                ),
                const SizedBox(height: AppSpacing.x2),
                SpotInfoRow(
                  label: context.l10n.spotDetailDuration,
                  value: context.l10n.spotDetailDurationMin(elapsed.inMinutes),
                ),
                const SizedBox(height: AppSpacing.x2),
                SpotInfoRow(
                  label: context.l10n.spotDetailTariff,
                  value: '$tarif $currency',
                ),
                const SizedBox(height: AppSpacing.x2),
                Divider(color: context.colors.outlineVariant, height: 1),
                const SizedBox(height: AppSpacing.x2),
                SpotInfoRow(
                  label: context.l10n.spotDetailGameTime,
                  value: '$timeAmount $currency',
                ),
                if (productsAmount > 0) ...[
                  const SizedBox(height: AppSpacing.x2),
                  SpotInfoRow(
                    label: context.l10n.spotDetailProductsTotal,
                    value: '$productsAmount $currency',
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
