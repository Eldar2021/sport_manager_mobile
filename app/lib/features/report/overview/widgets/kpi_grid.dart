import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class KpiGrid extends StatelessWidget {
  const KpiGrid(this.cubit, {super.key});

  final ReportOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
      bloc: cubit,
      buildWhen: (a, b) => a.summary != b.summary,
      builder: (_, state) => switch (state.summary) {
        RequestInitial<ReportsSummaryModel>() || RequestLoading<ReportsSummaryModel>() => const _KpiSkeleton(),
        RequestFailure<ReportsSummaryModel>() => Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Center(child: Text(context.l10n.reportsErrorTitle)),
          ),
        ),
        RequestSuccess<ReportsSummaryModel>(:final data) => _KpiGridContent(data),
      },
    );
  }
}

class _KpiGridContent extends StatelessWidget {
  const _KpiGridContent(this.summary);

  final ReportsSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ReportKpiCard(
              title: context.l10n.reportsKpiRevenue,
              value: ReportFormat.money(
                summary.totalRevenue,
                summary.currency,
              ),
              deltaPercent: summary.revenueDeltaPercent,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: ReportKpiCard(
              title: context.l10n.reportsKpiSessions,
              value: summary.totalSessions.toString(),
              deltaPercent: summary.sessionsDeltaPercent,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiSkeleton extends StatelessWidget {
  const _KpiSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: _SkeletonCard()),
            SizedBox(width: AppSpacing.x3),
            Expanded(child: _SkeletonCard()),
          ],
        ),
        SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(child: _SkeletonCard()),
            SizedBox(width: AppSpacing.x3),
            Expanded(child: _SkeletonCard()),
          ],
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShimmerBox(height: 12, width: 80),
            SizedBox(height: AppSpacing.x2),
            ShimmerBox(height: 22, width: 120),
            SizedBox(height: AppSpacing.x1),
            ShimmerBox(height: 12, width: 60),
          ],
        ),
      ),
    );
  }
}
