import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Body of [ManagerReportDetailView] — header card, KPI band, risk score,
/// fraud signals and the filterable session log. Lives in its own file so
/// the view stays declarative and short.
class ManagerReportBody extends StatelessWidget {
  const ManagerReportBody({
    required this.cubit,
    required this.detail,
    super.key,
  });

  final ManagerReportDetailCubit cubit;
  final ManagerReportDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = detail.summary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(summary),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: ReportKpiCard(
                title: l10n.reportsKpiRevenue,
                value: ReportFormat.money(summary.revenue, summary.currency),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: ReportKpiCard(
                title: l10n.reportsKpiSessions,
                value: summary.sessions.toString(),
                subtitle: '${summary.cancelCount} ${l10n.reportsCancelledShort}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        RiskScorePanel(summary),
        const SizedBox(height: AppSpacing.x4),
        Text(
          l10n.reportsFraudSignalsTitle,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        FraudFlagList(summary.flags),
        const SizedBox(height: AppSpacing.x6),
        ManagerSessionLog(
          cubit: cubit,
          entries: detail.sessionLog,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.summary);

  final ManagerReportRowModel summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: context.colors.primaryContainer,
          child: Text(
            _initials(summary.name),
            style: TextStyle(color: context.colors.onPrimaryContainer),
          ),
        ),
        title: Text(
          summary.name,
          style: context.textTheme.titleMedium,
        ),
        subtitle: Text(
          '@${summary.username}',
          style: context.appTextStyles.muted.labelSmall,
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts.first.isNotEmpty && parts.last.isNotEmpty) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }
}
