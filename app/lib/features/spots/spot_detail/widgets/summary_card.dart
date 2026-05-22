import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.tarif,
    required this.currency,
    super.key,
  });

  final int tarif;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.buttonBorderRadius,
        color: context.colors.outlineVariant,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x2),
        child: BlocSelector<SessionActiveCubit, SessionActiveState, (int, int)>(
          selector: (s) => (s.elapsed.inMinutes, s.currentAmount),
          builder: (context, data) {
            final (minutes, subtotal) = data;
            return Column(
              children: [
                const SizedBox(height: AppSpacing.x2),
                SpotInfoRow(
                  label: context.l10n.spotDetailDuration,
                  value: context.l10n.spotDetailDurationMin(minutes),
                ),
                const SizedBox(height: AppSpacing.x2),
                SpotInfoRow(
                  label: context.l10n.spotDetailTariff,
                  value: '$tarif $currency',
                ),
                const SizedBox(height: AppSpacing.x2),
                Divider(color: context.colors.outline, height: 1),
                const SizedBox(height: AppSpacing.x2),
                SpotInfoRow(
                  label: context.l10n.spotDetailSubtotal,
                  value: '$subtotal $currency',
                ),
                const SizedBox(height: AppSpacing.x4),
              ],
            );
          },
        ),
      ),
    );
  }
}
