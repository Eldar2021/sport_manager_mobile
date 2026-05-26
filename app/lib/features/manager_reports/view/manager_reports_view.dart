import 'package:flutter/material.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/features/manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Root screen for "Мои отчёты" — title, four pill chips, and an
/// `IndexedStack` so each period view stays alive (via the children's
/// `AutomaticKeepAliveClientMixin`) after first activation. Cubits live
/// inside each period's `StatefulWidget`.
class ManagerReportsView extends StatefulWidget {
  const ManagerReportsView({super.key});

  @override
  State<ManagerReportsView> createState() => _ManagerReportsViewState();
}

class _ManagerReportsViewState extends State<ManagerReportsView> {
  ManagerReportPeriod _selected = ManagerReportPeriod.today;

  static const List<ManagerReportPeriod> _order = ManagerReportPeriod.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.managerReportsTitle),
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.x2),
          ManagerReportChipBar(
            selected: _selected,
            onSelected: (p) => setState(() => _selected = p),
          ),
          const SizedBox(height: AppSpacing.x2),
          Expanded(
            child: IndexedStack(
              index: _order.indexOf(_selected),
              children: const [
                TodayView(),
                WeekView(),
                MonthView(),
                YearView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
