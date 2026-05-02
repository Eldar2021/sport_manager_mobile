import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/core/exeptions/widget/error_body_widget.dart';
import 'package:sport_manager_mobile/features/report/manager_detail/cubit/manager_report_detail_cubit.dart';
import 'package:sport_manager_mobile/features/report/manager_detail/widgets/fraud_flag_list.dart';
import 'package:sport_manager_mobile/features/report/manager_detail/widgets/manager_session_log.dart';
import 'package:sport_manager_mobile/features/report/manager_detail/widgets/risk_score_panel.dart';
import 'package:sport_manager_mobile/features/report/utils/report_format.dart';
import 'package:sport_manager_mobile/features/report/widgets/report_kpi_card.dart';
import 'package:sport_manager_mobile/features/report/widgets/report_period_chips.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ManagerReportDetailView extends StatefulWidget {
  const ManagerReportDetailView({required this.managerId, super.key});

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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsManagerDetailTitle)),
      body: RefreshIndicator.adaptive(
        onRefresh: _cubit.load,
        child: BlocBuilder<ManagerReportDetailCubit, ManagerReportDetailState>(
          bloc: _cubit,
          buildWhen: (a, b) => a.detail != b.detail || a.filter.period != b.filter.period,
          builder: (_, state) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: AppSpacing.x6),
              children: [
                const SizedBox(height: AppSpacing.x3),
                ReportPeriodChips(
                  value: state.filter.period,
                  onChanged: _cubit.changePeriod,
                ),
                const SizedBox(height: AppSpacing.x4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                  child: switch (state.detail) {
                    RequestInitial<ManagerReportDetailModel>() ||
                    RequestLoading<ManagerReportDetailModel>() => const _Skeleton(),
                    RequestFailure<ManagerReportDetailModel>(:final exception) => ErrorBodyWidget(
                      exception,
                      onRetryPressed: _cubit.load,
                    ),
                    RequestSuccess<ManagerReportDetailModel>(:final data) => _Body(
                      cubit: _cubit,
                      detail: data,
                    ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.cubit, required this.detail});

  final ManagerReportDetailCubit cubit;
  final ManagerReportDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = detail.summary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: context.colors.primaryContainer,
                  child: Text(
                    _initials(summary.name),
                    style: TextStyle(color: context.colors.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(summary.name, style: context.textTheme.titleMedium),
                      Text('@${summary.username}', style: context.appTextStyles.muted.labelSmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: ReportKpiCard(
                title: l10n.reportsKpiRevenue,
                value: ReportFormat.money(summary.revenue, summary.currency),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: ReportKpiCard(
                title: l10n.reportsKpiSessions,
                value: summary.sessions.toString(),
                subtitle: '${summary.cancelCount} ${l10n.reportsCancelledShort}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        RiskScorePanel(row: summary),
        const SizedBox(height: AppSpacing.x4),
        Text(l10n.reportsFraudSignalsTitle, style: context.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.x2),
        FraudFlagList(flags: summary.flags),
        const SizedBox(height: AppSpacing.x6),
        ManagerSessionLog(cubit: cubit, entries: detail.sessionLog),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts.first.isNotEmpty && parts.last.isNotEmpty) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 80),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 96),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 140),
        SizedBox(height: AppSpacing.x4),
        ShimmerBox(height: 80),
      ],
    );
  }
}
