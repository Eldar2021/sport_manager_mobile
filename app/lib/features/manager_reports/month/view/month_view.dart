import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class MonthView extends StatefulWidget {
  const MonthView({super.key});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> with AutomaticKeepAliveClientMixin {
  late final MonthCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MonthCubit(
      GetIt.I<ManagerReportsRepository>(),
    )..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _openDay(DayCardModel day) {
    final iso =
        '${day.date.year.toString().padLeft(4, '0')}'
        '-${day.date.month.toString().padLeft(2, '0')}'
        '-${day.date.day.toString().padLeft(2, '0')}';
    context.push(AppRoutes.managerReportsDay.replaceFirst(':date', iso));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: _cubit.load,
      child: BlocBuilder<MonthCubit, DataState<MonthReportModel>>(
        bloc: _cubit,
        builder: (_, state) => switch (state) {
          DataInitial() || DataLoading() => const ManagerReportSkeleton(),
          DataFailure(:final exception) => _FailureBody(
            exception: exception,
            onRetry: _cubit.load,
          ),
          DataSuccess(:final data) => _MonthBody(
            data: data,
            onDayTap: _openDay,
          ),
        },
      ),
    );
  }
}

class _MonthBody extends StatelessWidget {
  const _MonthBody({
    required this.data,
    required this.onDayTap,
  });

  final MonthReportModel data;
  final ValueChanged<DayCardModel> onDayTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x8,
      ),
      children: [
        ManagerReportHeader(
          eyebrow: l10n.managerReportsHeaderMonth,
          title: ManagerReportFormat.monthYear(
            data.year,
            data.month,
            l10n,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        ManagerReportSummaryCard(
          title: l10n.managerReportsSummaryEarnedMonth,
          revenue: data.summary.revenue,
          currency: data.summary.currency,
          sessions: data.summary.sessions,
          shiftSeconds: data.summary.shiftSeconds,
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final d in data.days) ...[
          ManagerReportDayTile(d, onTap: onDayTap),
          const SizedBox(height: AppSpacing.x2),
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
