import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RevenueChartSection extends StatelessWidget {
  const RevenueChartSection(this.cubit, {super.key});

  final ReportOverviewCubit cubit;

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
              context.l10n.reportsRevenueChartTitle,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.x3),
            BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
              bloc: cubit,
              buildWhen: (a, b) => a.revenue != b.revenue || a.summary != b.summary,
              builder: (_, state) {
                final currency = state.summary.dataOrNull?.currency ?? Currency.kgs;
                return switch (state.revenue) {
                  RequestInitial<List<RevenuePointModel>>() ||
                  RequestLoading<List<RevenuePointModel>>() => const ShimmerBox(height: 140),
                  RequestFailure<List<RevenuePointModel>>() => SizedBox(
                    height: 140,
                    child: Center(child: Text(context.l10n.reportsErrorTitle)),
                  ),
                  RequestSuccess<List<RevenuePointModel>>(:final data) => RevenueBarChart(
                    points: data,
                    currency: currency,
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
