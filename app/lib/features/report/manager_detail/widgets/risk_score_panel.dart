import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RiskScorePanel extends StatelessWidget {
  const RiskScorePanel(this.row, {super.key});

  final ManagerReportRowModel row;

  Color _bandColor(BuildContext context) {
    return switch (row.riskBand) {
      ManagerRiskBand.green => context.appColors.success,
      ManagerRiskBand.yellow => context.appColors.warning,
      ManagerRiskBand.red => context.colors.error,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = _bandColor(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.reportsRiskScoreTitle, style: context.textTheme.titleSmall),
                ),
                ManagerRiskBadge(row.riskBand),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${row.riskScore}',
                  style: context.textTheme.displaySmall?.copyWith(color: c),
                ),
                const SizedBox(width: AppSpacing.x1),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                  child: Text(
                    '/ 100',
                    style: context.appTextStyles.muted.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: row.riskScore / 100,
                minHeight: 6,
                backgroundColor: context.colors.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(c),
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              l10n.reportsRiskScoreExplain,
              style: context.appTextStyles.muted.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
