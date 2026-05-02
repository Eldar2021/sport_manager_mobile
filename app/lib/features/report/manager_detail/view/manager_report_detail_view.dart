import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ManagerReportDetailView extends StatefulWidget {
  const ManagerReportDetailView(this.managerId, {super.key});

  final String managerId;

  @override
  State<ManagerReportDetailView> createState() => _ManagerReportDetailViewState();
}

class _ManagerReportDetailViewState extends State<ManagerReportDetailView> {
  late final ManagerReportDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ManagerReportDetailCubit(
      repository: GetIt.I<ReportsRepository>(),
      managerId: widget.managerId,
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
        title: Text(context.l10n.reportsManagerDetailTitle),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _cubit.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.x6),
          children: [
            const SizedBox(height: AppSpacing.x3),
            BlocBuilder<ManagerReportDetailCubit, ManagerReportDetailState>(
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
              child: BlocBuilder<ManagerReportDetailCubit, ManagerReportDetailState>(
                bloc: _cubit,
                buildWhen: (a, b) => a.detail != b.detail,
                builder: (_, state) => switch (state.detail) {
                  RequestInitial<ManagerReportDetailModel>() ||
                  RequestLoading<ManagerReportDetailModel>() => const ManagerReportDetailSkeleton(),
                  RequestFailure<ManagerReportDetailModel>(:final exception) => ErrorBodyWidget(
                    exception,
                    onRetryPressed: _cubit.load,
                  ),
                  RequestSuccess<ManagerReportDetailModel>(:final data) => ManagerReportBody(
                    cubit: _cubit,
                    detail: data,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
