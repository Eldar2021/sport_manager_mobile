import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ReportPeriodChips extends StatelessWidget {
  const ReportPeriodChips({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ReportPeriod value;
  final ValueChanged<ReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: Row(
        children: [
          for (final p in const [
            ReportPeriod.today,
            ReportPeriod.week,
            ReportPeriod.month,
            ReportPeriod.year,
          ])
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.x2),
              child: ChoiceChip(
                label: Text(_label(p, l10n)),
                selected: value == p,
                onSelected: (_) => onChanged(p),
              ),
            ),
        ],
      ),
    );
  }

  String _label(ReportPeriod p, AppLocalizations l10n) {
    return switch (p) {
      ReportPeriod.today => l10n.reportsPeriodToday,
      ReportPeriod.week => l10n.reportsPeriodWeek,
      ReportPeriod.month => l10n.reportsPeriodMonth,
      ReportPeriod.year => l10n.reportsPeriodYear,
      ReportPeriod.custom => l10n.reportsPeriodCustom,
    };
  }
}
