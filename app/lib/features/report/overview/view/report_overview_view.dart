import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:product/product.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ReportOverviewView extends StatefulWidget {
  const ReportOverviewView({super.key});

  @override
  State<ReportOverviewView> createState() => _ReportOverviewViewState();
}

class _ReportOverviewViewState extends State<ReportOverviewView> with SingleTickerProviderStateMixin {
  late final ReportOverviewCubit _cubit;
  late final TabController _tabController;

  static const List<ReportPeriod> _periods = ReportPeriodTabs.periods;

  @override
  void initState() {
    super.initState();
    _cubit = ReportOverviewCubit(
      GetIt.I<ReportsRepository>(),
      GetIt.I<ProductRepository>(),
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

  VenueType _resolveVenueType(BuildContext context) {
    final state = context.read<HomeCubit>().state;
    return switch (state) {
      HomeLoaded(:final venue) || HomeNoSpots(:final venue) => venue.type,
      _ => VenueType.billiards,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reportsOverviewTitle),
        actions: [
          BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
            bloc: _cubit,
            buildWhen: (a, b) => a.venues != b.venues || a.filter.venueId != b.filter.venueId,
            builder: (_, state) => ReportVenuePicker(
              venues: state.venues.dataOrNull ?? const <ReportVenueModel>[],
              selectedVenueId: state.filter.venueId,
              onSelected: _cubit.changeVenue,
            ),
          ),
        ],
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
                    child: BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
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
                padding: const EdgeInsets.only(bottom: AppSpacing.x6),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        KpiGrid(_cubit),
                        const SizedBox(height: AppSpacing.x4),
                        RevenueChartSection(_cubit),
                        const SizedBox(height: AppSpacing.x4),
                        ForecastSummaryCard(_cubit),
                        const SizedBox(height: AppSpacing.x6),
                        SpotsSection(cubit: _cubit, venueType: _resolveVenueType(context)),
                        const SizedBox(height: AppSpacing.x6),
                        TopManagersSection(_cubit),
                        const SizedBox(height: AppSpacing.x6),
                        TopProductsSection(_cubit),
                      ],
                    ),
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
