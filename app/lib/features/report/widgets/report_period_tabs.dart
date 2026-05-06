import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ReportPeriodTabs extends StatelessWidget {
  const ReportPeriodTabs(this.controller, {super.key});

  final TabController controller;

  static const List<ReportPeriod> periods = [
    ReportPeriod.today,
    ReportPeriod.week,
    ReportPeriod.month,
    ReportPeriod.year,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppPillTabBar(
      controller: controller,
      tabs: [
        for (final p in periods) Tab(text: _label(p, l10n)),
      ],
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
