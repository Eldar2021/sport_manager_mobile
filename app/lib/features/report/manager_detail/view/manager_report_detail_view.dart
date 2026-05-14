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
  const ManagerReportDetailView({
    required this.managerId,
    required this.venueId,
    super.key,
  });

  final String managerId;
  final String venueId;

  @override
  State<ManagerReportDetailView> createState() => _ManagerReportDetailViewState();
}

class _ManagerReportDetailViewState extends State<ManagerReportDetailView> with SingleTickerProviderStateMixin {
  late final ManagerReportDetailCubit _cubit;
  late final TabController _tabController;

  static const List<ReportPeriod> _periods = ReportPeriodTabs.periods;

  @override
  void initState() {
    super.initState();
    _cubit = ManagerReportDetailCubit(
      repository: GetIt.I<ReportsRepository>(),
      managerId: widget.managerId,
      venueId: widget.venueId,
    );
    _tabController = TabController(
      length: _periods.length,
      vsync: this,
      initialIndex: _periods.indexOf(_cubit.state.filter.period),
    );
    _tabController.addListener(_onTabChanged);
    _cubit.load();
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _cubit.close();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _cubit.changePeriod(_periods[_tabController.index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reportsManagerDetailTitle),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _cubit.load,
        child: NestedScrollView(
          headerSliverBuilder: (_, _) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.x3),
                  ReportPeriodTabs(_tabController),
                  const SizedBox(height: AppSpacing.x4),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: List.generate(
              _periods.length,
              (_) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                children: [
                  BlocBuilder<ManagerReportDetailCubit, ManagerReportDetailState>(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
