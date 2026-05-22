import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SpotReportDetailView extends StatefulWidget {
  const SpotReportDetailView({
    required this.spotId,
    required this.venueId,
    super.key,
  });

  final String spotId;
  final String venueId;

  @override
  State<SpotReportDetailView> createState() => _SpotReportDetailViewState();
}

class _SpotReportDetailViewState extends State<SpotReportDetailView> with SingleTickerProviderStateMixin {
  late final SpotReportDetailCubit _cubit;
  late final TabController _tabController;
  late VenueType _venueType;

  static const List<ReportPeriod> _periods = ReportPeriodTabs.periods;

  @override
  void initState() {
    super.initState();
    _cubit = SpotReportDetailCubit(
      repository: GetIt.I<ReportsRepository>(),
      spotId: widget.spotId,
      venueId: widget.venueId,
    );
    _tabController = TabController(
      length: _periods.length,
      vsync: this,
      initialIndex: _periods.indexOf(_cubit.state.filter.period),
    );
    _tabController.addListener(_onTabChanged);
    _venueType = _resolveVenueType(context);
    _cubit.load();
  }

  VenueType _resolveVenueType(BuildContext context) {
    final state = context.read<HomeCubit>().state;
    return switch (state) {
      HomeLoaded(:final venue) || HomeNoSpots(:final venue) => venue.type,
      _ => VenueType.billiards,
    };
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
        title: Text(context.l10n.reportsSpotDetailTitle),
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
                  const SizedBox(height: AppSpacing.x3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                    child: BlocBuilder<SpotReportDetailCubit, SpotReportDetailState>(
                      bloc: _cubit,
                      buildWhen: (a, b) => a.filter != b.filter,
                      builder: (_, state) => ReportComparisonLabel(state.filter),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
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
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x4,
                  0,
                  AppSpacing.x4,
                  AppSpacing.x6,
                ),
                children: [
                  BlocBuilder<SpotReportDetailCubit, SpotReportDetailState>(
                    bloc: _cubit,
                    buildWhen: (a, b) => a.detail != b.detail || a.filter.period != b.filter.period,
                    builder: (_, state) => switch (state.detail) {
                      RequestInitial<SpotReportDetailModel>() ||
                      RequestLoading<SpotReportDetailModel>() => const SpotReportDetailSkeleton(),
                      RequestFailure<SpotReportDetailModel>(:final exception) => ErrorBodyWidget(
                        exception,
                        onRetryPressed: _cubit.load,
                      ),
                      RequestSuccess<SpotReportDetailModel>(:final data) => SpotReportBody(
                        detail: data,
                        period: state.filter.period,
                        venueType: _venueType,
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
