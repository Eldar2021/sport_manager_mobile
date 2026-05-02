import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/core/exeptions/widget/error_body_widget.dart';
import 'package:sport_manager_mobile/features/report/table_detail/cubit/table_report_detail_cubit.dart';
import 'package:sport_manager_mobile/features/report/table_detail/widgets/hour_day_heatmap.dart';
import 'package:sport_manager_mobile/features/report/utils/report_format.dart';
import 'package:sport_manager_mobile/features/report/widgets/report_kpi_card.dart';
import 'package:sport_manager_mobile/features/report/widgets/report_period_chips.dart';
import 'package:sport_manager_mobile/features/report/widgets/revenue_bar_chart.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TableReportDetailView extends StatefulWidget {
  const TableReportDetailView({required this.tableId, super.key});

  final String tableId;

  @override
  State<TableReportDetailView> createState() => _TableReportDetailViewState();
}

class _TableReportDetailViewState extends State<TableReportDetailView> {
  late final TableReportDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = TableReportDetailCubit(
      repository: GetIt.I<ReportsRepository>(),
      tableId: widget.tableId,
    );
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTableDetailTitle)),
      body: RefreshIndicator.adaptive(
        onRefresh: _cubit.load,
        child: BlocBuilder<TableReportDetailCubit, TableReportDetailState>(
          bloc: _cubit,
          builder: (_, state) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: AppSpacing.x6),
              children: [
                const SizedBox(height: AppSpacing.x3),
                ReportPeriodChips(
                  value: state.filter.period,
                  onChanged: _cubit.changePeriod,
                ),
                const SizedBox(height: AppSpacing.x4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                  child: switch (state.detail) {
                    RequestInitial<TableReportDetailModel>() ||
                    RequestLoading<TableReportDetailModel>() => const _Skeleton(),
                    RequestFailure<TableReportDetailModel>(:final exception) => ErrorBodyWidget(
                      exception,
                      onRetryPressed: _cubit.load,
                    ),
                    RequestSuccess<TableReportDetailModel>(:final data) => _Body(detail: data),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.detail});

  final TableReportDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = detail.summary;
    final tableLabel = summary.tableName == null || summary.tableName!.isEmpty
        ? '${l10n.reportsTableLabel} ${summary.tableNumber}'
        : '${l10n.reportsTableLabel} ${summary.tableNumber} · «${summary.tableName}»';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(tableLabel, style: context.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.x1),
        Text(summary.venueName, style: context.appTextStyles.muted.labelSmall),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: ReportKpiCard(
                title: l10n.reportsKpiRevenue,
                value: ReportFormat.money(summary.revenue, summary.currency),
                deltaPercent: summary.deltaPercent,
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
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: ReportKpiCard(
                title: l10n.reportsKpiAvgDuration,
                value: ReportFormat.duration(summary.avgDurationSeconds),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: ReportKpiCard(
                title: l10n.reportsKpiOccupancy,
                value: '${summary.occupancyPercent}%',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reportsTableTrendTitle, style: context.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.x3),
                RevenueBarChart(points: detail.revenueByDay, currency: summary.currency),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(l10n.reportsTableHeatmapTitle, style: context.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.x2),
        HourDayHeatmap(heatmap: detail.hourHeatmap),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 24),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 96),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 200),
      ],
    );
  }
}
