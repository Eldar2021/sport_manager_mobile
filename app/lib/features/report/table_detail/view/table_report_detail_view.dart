import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TableReportDetailView extends StatefulWidget {
  const TableReportDetailView(this.tableId, {super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reportsTableDetailTitle),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _cubit.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.x6),
          children: [
            const SizedBox(height: AppSpacing.x3),
            BlocBuilder<TableReportDetailCubit, TableReportDetailState>(
              bloc: _cubit,
              buildWhen: (a, b) => a.filter.period != b.filter.period,
              builder: (_, state) => ReportPeriodChips(
                value: state.filter.period,
                onChanged: _cubit.changePeriod,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: BlocBuilder<TableReportDetailCubit, TableReportDetailState>(
                bloc: _cubit,
                buildWhen: (a, b) => a.detail != b.detail,
                builder: (_, state) => switch (state.detail) {
                  RequestInitial<TableReportDetailModel>() ||
                  RequestLoading<TableReportDetailModel>() => const TableReportDetailSkeleton(),
                  RequestFailure<TableReportDetailModel>(:final exception) => ErrorBodyWidget(
                    exception,
                    onRetryPressed: _cubit.load,
                  ),
                  RequestSuccess<TableReportDetailModel>(:final data) => TableReportBody(data),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
