import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
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
                TableInfoRow(
                  label: context.l10n.tableDetailDuration,
                  value: context.l10n.tableDetailDurationMin(minutes),
                ),
                const SizedBox(height: AppSpacing.x2),
                TableInfoRow(
                  label: context.l10n.tableDetailTariff,
                  value: '$tarif $currency',
                ),
                const SizedBox(height: AppSpacing.x2),
                Divider(color: context.colors.outline, height: 1),
                const SizedBox(height: AppSpacing.x2),
                TableInfoRow(
                  label: context.l10n.tableDetailSubtotal,
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
