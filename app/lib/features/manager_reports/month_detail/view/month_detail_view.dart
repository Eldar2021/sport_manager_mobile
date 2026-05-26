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

class MonthDetailView extends StatefulWidget {
  const MonthDetailView({
    required this.year,
    required this.month,
    super.key,
  });

  final int year;
  final int month;

  @override
  State<MonthDetailView> createState() => _MonthDetailViewState();
}

class _MonthDetailViewState extends State<MonthDetailView> {
  late final MonthDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MonthDetailCubit(
      GetIt.I<ManagerReportsRepository>(),
      widget.year,
      widget.month,
    )..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openDay(DayCardModel day) {
    final iso =
        '${day.date.year.toString().padLeft(4, '0')}'
        '-${day.date.month.toString().padLeft(2, '0')}'
        '-${day.date.day.toString().padLeft(2, '0')}';
    context.push(AppRoutes.managerReportsDay.replaceFirst(':date', iso));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<MonthDetailCubit, DataState<MonthReportModel>>(
          bloc: _cubit,
          buildWhen: (a, b) => a is! DataSuccess && b is DataSuccess,
          builder: (_, state) {
            final data = state.dataValue;
            final title = data == null
                ? ManagerReportFormat.monthYear(
                    widget.year,
                    widget.month,
                    l10n,
                  )
                : ManagerReportFormat.monthShortYear(
                    data.monthShort,
                    data.year,
                    l10n,
                  );
            return Text(title);
          },
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _cubit.load,
        child: BlocBuilder<MonthDetailCubit, DataState<MonthReportModel>>(
          bloc: _cubit,
          builder: (_, state) => switch (state) {
            DataInitial() || DataLoading() => const ManagerReportSkeleton(),
            DataFailure(:final exception) => _FailureBody(
              exception: exception,
              onRetry: _cubit.load,
            ),
            DataSuccess(:final data) => _MonthDetailBody(
              data: data,
              onDayTap: _openDay,
            ),
          },
        ),
      ),
    );
  }
}

class _MonthDetailBody extends StatelessWidget {
  const _MonthDetailBody({
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
        ManagerReportSummaryCard(
          title: l10n.managerReportsMonthDetailSummary(
            ManagerReportFormat.monthShortYear(
              data.monthShort,
              data.year,
              l10n,
            ),
          ),
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
        ErrorBodyWidget(exception, onRetryPressed: onRetry),
      ],
    );
  }
}
