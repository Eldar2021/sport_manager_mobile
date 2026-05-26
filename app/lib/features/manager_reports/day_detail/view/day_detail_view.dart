import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class DayDetailView extends StatefulWidget {
  const DayDetailView({required this.date, super.key});

  final DateTime date;

  @override
  State<DayDetailView> createState() => _DayDetailViewState();
}

class _DayDetailViewState extends State<DayDetailView> {
  late final DayDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DayDetailCubit(
      GetIt.I<ManagerReportsRepository>(),
      widget.date,
    )..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.managerReportsBackToDay)),
      body: RefreshIndicator.adaptive(
        onRefresh: _cubit.load,
        child: BlocBuilder<DayDetailCubit, DataState<DayReportModel>>(
          bloc: _cubit,
          builder: (_, state) => switch (state) {
            DataInitial() || DataLoading() => const ManagerReportSkeleton(),
            DataFailure(:final exception) => _FailureBody(
              exception: exception,
              onRetry: _cubit.load,
            ),
            DataSuccess(:final data) => _DayDetailBody(data),
          },
        ),
      ),
    );
  }
}

class _DayDetailBody extends StatelessWidget {
  const _DayDetailBody(this.data);

  final DayReportModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sessions = data.sessions;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x8,
      ),
      children: [
        ManagerReportHeader(
          eyebrow: ManagerReportFormat.dayOfWeekFull(data.dayOfWeek, l10n),
          title: ManagerReportFormat.fullDate(data.date, l10n),
        ),
        const SizedBox(height: AppSpacing.x3),
        ManagerReportSummaryCard(
          title: l10n.managerReportsSummaryEarnedToday,
          revenue: data.summary.revenue,
          currency: data.summary.currency,
          sessions: data.summary.sessions,
          shiftSeconds: data.summary.shiftSeconds,
        ),
        const SizedBox(height: AppSpacing.x4),
        if (sessions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x6),
            child: Text(
              l10n.managerReportsDayOff,
              textAlign: TextAlign.center,
              style: context.appTextStyles.muted.titleMedium,
            ),
          )
        else ...[
          Text(
            l10n.managerReportsSessionsListLabel(sessions.length),
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          for (final s in sessions) ...[
            ManagerReportSessionTile(s),
            const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ],
    );
  }
}

class _FailureBody extends StatelessWidget {
  const _FailureBody({
    required this.exception,
    required this.onRetry,
  });

  final Object exception;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: AppSpacing.x10),
        ErrorBodyWidget(
          exception,
          onRetryPressed: onRetry,
        ),
      ],
    );
  }
}
