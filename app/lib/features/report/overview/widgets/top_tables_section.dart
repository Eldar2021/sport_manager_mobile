import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TopTablesSection extends StatelessWidget {
  const TopTablesSection(this.cubit, {super.key});

  final ReportOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reportsTopTablesTitle,
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.x2),
        BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
          bloc: cubit,
          buildWhen: (a, b) => a.tables != b.tables || a.filter.venueId != b.filter.venueId,
          builder: (_, state) => switch (state.tables) {
            RequestInitial<List<TableReportRowModel>>() ||
            RequestLoading<List<TableReportRowModel>>() => const TopTablesSkeleton(),
            RequestFailure<List<TableReportRowModel>>() => _MessageCard(l10n.reportsErrorTitle),
            RequestSuccess<List<TableReportRowModel>>(:final data) when data.isEmpty => _MessageCard(
              l10n.reportsEmptySubtitle,
            ),
            RequestSuccess<List<TableReportRowModel>>(:final data) => _TablesCard(
              data: data,
              showVenue: state.filter.venueId == null,
            ),
          },
        ),
      ],
    );
  }
}

class _TablesCard extends StatelessWidget {
  const _TablesCard({
    required this.data,
    required this.showVenue,
  });

  final List<TableReportRowModel> data;
  final bool showVenue;

  @override
  Widget build(BuildContext context) {
    final maxRevenue = data.first.revenue == 0 ? 1 : data.first.revenue;
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < data.length; i++) ...[
            if (i != 0) const Divider(height: 1),
            TopTablesRow(
              row: data[i],
              showVenue: showVenue,
              maxRevenue: maxRevenue,
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Center(child: Text(message)),
      ),
    );
  }
}
