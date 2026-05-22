import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Body of [SpotReportDetailView]: spot label, KPI band, period-aware
/// trend chart and the hour-of-day heatmap. Kept in its own file so the
/// view stays declarative and short.
class SpotReportBody extends StatelessWidget {
  const SpotReportBody({
    required this.detail,
    required this.period,
    required this.venueType,
    super.key,
  });

  final SpotReportDetailModel detail;
  final ReportPeriod period;
  final VenueType venueType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = detail.summary;
    final spotLabel = _spotLabel(summary, l10n, venueType.spotLabel(context));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          spotLabel,
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          summary.venueName,
          style: context.appTextStyles.muted.labelSmall,
        ),
        const SizedBox(height: AppSpacing.x4),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ReportKpiCard(
                  title: l10n.reportsKpiRevenue,
                  value: ReportFormat.money(summary.revenue, summary.currency),
                  deltaPercent: period == ReportPeriod.today ? null : summary.deltaPercent,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: ReportKpiCard(
                  title: l10n.reportsKpiSessions,
                  value: summary.sessions.toString(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _TrendCard(
          points: detail.revenueSeries,
          currency: summary.currency,
          period: period,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          l10n.reportsSpotHeatmapTitle,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        HourDayHeatmap(detail.hourHeatmap),
      ],
    );
  }

  String _spotLabel(SpotReportRowModel s, AppLocalizations l10n, String spotLabelWord) {
    if (s.spotName == null || s.spotName!.isEmpty) {
      return '$spotLabelWord ${s.spotNumber}';
    }
    return '$spotLabelWord ${s.spotNumber} · «${s.spotName}»';
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({
    required this.points,
    required this.currency,
    required this.period,
  });

  final List<RevenuePointModel> points;
  final Currency currency;
  final ReportPeriod period;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.reportsSpotTrendTitle,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.x3),
            RevenueBarChart(
              points: points,
              currency: currency,
              period: period,
            ),
          ],
        ),
      ),
    );
  }
}
