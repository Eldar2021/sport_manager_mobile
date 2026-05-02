import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/report/overview/cubit/report_overview_cubit.dart';
import 'package:sport_manager_mobile/features/report/utils/report_format.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TopTablesSection extends StatelessWidget {
  const TopTablesSection({required this.cubit, super.key});

  final ReportOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.reportsTopTablesTitle, style: context.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.x2),
        BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
          bloc: cubit,
          buildWhen: (a, b) => a.tables != b.tables || a.filter.venueId != b.filter.venueId,
          builder: (_, state) {
            return switch (state.tables) {
              RequestInitial<List<TableReportRowModel>>() ||
              RequestLoading<List<TableReportRowModel>>() => const _TablesSkeleton(),
              RequestFailure<List<TableReportRowModel>>() => Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Center(child: Text(l10n.reportsErrorTitle)),
                ),
              ),
              RequestSuccess<List<TableReportRowModel>>(:final data) when data.isEmpty => Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Center(child: Text(l10n.reportsEmptySubtitle)),
                ),
              ),
              RequestSuccess<List<TableReportRowModel>>(:final data) => Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var i = 0; i < data.length; i++) ...[
                      if (i != 0) const Divider(height: 1),
                      _TableRow(
                        row: data[i],
                        showVenue: state.filter.venueId == null,
                        maxRevenue: data.first.revenue == 0 ? 1 : data.first.revenue,
                      ),
                    ],
                  ],
                ),
              ),
            };
          },
        ),
      ],
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.row, required this.showVenue, required this.maxRevenue});

  final TableReportRowModel row;
  final bool showVenue;
  final int maxRevenue;

  @override
  Widget build(BuildContext context) {
    final ratio = (row.revenue / maxRevenue).clamp(0.0, 1.0);
    final delta = row.deltaPercent;
    final deltaColor = delta == null ? null : (delta > 0 ? context.appColors.success : context.colors.error);
    return InkWell(
      onTap: () => context.push('${AppRoutes.report}/tables/${row.tableId}'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _label(row, context.l10n),
                    style: context.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (delta != null) ...[
                  Icon(
                    delta > 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    size: 14,
                    color: deltaColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    ReportFormat.delta(delta),
                    style: context.textTheme.labelSmall?.copyWith(color: deltaColor),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(
                  ReportFormat.money(row.revenue, row.currency),
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 4,
                backgroundColor: context.colors.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
              ),
            ),
            if (showVenue) ...[
              const SizedBox(height: AppSpacing.x1),
              Text(row.venueName, style: context.appTextStyles.muted.labelSmall),
            ],
          ],
        ),
      ),
    );
  }

  String _label(TableReportRowModel r, AppLocalizations l10n) {
    final base = '${l10n.reportsTableLabel} ${r.tableNumber}';
    if (r.tableName != null && r.tableName!.isNotEmpty) {
      return '$base · «${r.tableName}»';
    }
    return base;
  }
}

class _TablesSkeleton extends StatelessWidget {
  const _TablesSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.x3),
        child: Column(
          children: [
            ShimmerBox(height: 16),
            SizedBox(height: AppSpacing.x2),
            ShimmerBox(height: 16),
            SizedBox(height: AppSpacing.x2),
            ShimmerBox(height: 16),
          ],
        ),
      ),
    );
  }
}
