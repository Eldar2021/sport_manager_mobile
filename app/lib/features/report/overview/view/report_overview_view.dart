import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/overview/cubit/report_overview_cubit.dart';
import 'package:sport_manager_mobile/features/report/overview/widgets/forecast_summary_card.dart';
import 'package:sport_manager_mobile/features/report/overview/widgets/insights_strip.dart';
import 'package:sport_manager_mobile/features/report/overview/widgets/kpi_grid.dart';
import 'package:sport_manager_mobile/features/report/overview/widgets/revenue_chart_section.dart';
import 'package:sport_manager_mobile/features/report/overview/widgets/top_managers_section.dart';
import 'package:sport_manager_mobile/features/report/overview/widgets/top_tables_section.dart';
import 'package:sport_manager_mobile/features/report/widgets/report_period_chips.dart';
import 'package:sport_manager_mobile/features/report/widgets/report_venue_picker.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ReportOverviewView extends StatefulWidget {
  const ReportOverviewView({super.key});

  @override
  State<ReportOverviewView> createState() => _ReportOverviewViewState();
}

class _ReportOverviewViewState extends State<ReportOverviewView> {
  late final ReportOverviewCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ReportOverviewCubit(repository: GetIt.I<ReportsRepository>());
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
      appBar: AppBar(
        title: Text(l10n.reportsOverviewTitle),
        actions: [
          BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
            bloc: _cubit,
            buildWhen: (a, b) => a.venues != b.venues || a.filter.venueId != b.filter.venueId,
            builder: (_, state) {
              final venues = state.venues.dataOrNull ?? const <ReportVenueModel>[];
              return ReportVenuePicker(
                venues: venues,
                selectedVenueId: state.filter.venueId,
                onSelected: _cubit.changeVenue,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _cubit.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.x6),
          children: [
            const SizedBox(height: AppSpacing.x3),
            BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
              bloc: _cubit,
              buildWhen: (a, b) => a.filter.period != b.filter.period,
              builder: (_, state) => ReportPeriodChips(
                value: state.filter.period,
                onChanged: _cubit.changePeriod,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            InsightsStrip(cubit: _cubit),
            const SizedBox(height: AppSpacing.x3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KpiGrid(cubit: _cubit),
                  const SizedBox(height: AppSpacing.x4),
                  RevenueChartSection(cubit: _cubit),
                  const SizedBox(height: AppSpacing.x4),
                  ForecastSummaryCard(cubit: _cubit),
                  const SizedBox(height: AppSpacing.x6),
                  TopTablesSection(cubit: _cubit),
                  const SizedBox(height: AppSpacing.x6),
                  TopManagersSection(cubit: _cubit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
