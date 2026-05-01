import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
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
        child: Column(
          children: [
            TableInfoRow(
              label: context.l10n.tableDetailStartTime,
              value: DateFormat('HH:mm').format(session.startedAt),
            ),
            const SizedBox(height: AppSpacing.x2),
            TableInfoRow(
              label: context.l10n.tableDetailDuration,
              value: context.l10n.tableDetailDurationMin(elapsed.inMinutes),
            ),
            const SizedBox(height: AppSpacing.x2),
            TableInfoRow(
              label: context.l10n.tableDetailTariff,
              value: '$tarif $currency',
            ),
          ],
        ),
      ),
    );
  }
}
