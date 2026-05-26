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

class YearView extends StatefulWidget {
  const YearView({super.key});

  @override
  State<YearView> createState() => _YearViewState();
}

class _YearViewState extends State<YearView> with AutomaticKeepAliveClientMixin {
  late final YearCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = YearCubit(GetIt.I<ManagerReportsRepository>())..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _openMonth(MonthCardModel month) {
    final ym =
        '${month.year.toString().padLeft(4, '0')}'
        '-${month.month.toString().padLeft(2, '0')}';
    context.push(AppRoutes.managerReportsMonth.replaceFirst(':yearMonth', ym));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: _cubit.load,
      child: BlocBuilder<YearCubit, DataState<YearReportModel>>(
        bloc: _cubit,
        builder: (_, state) => switch (state) {
          DataInitial() || DataLoading() => const ManagerReportSkeleton(),
          DataFailure(:final exception) => _FailureBody(
            exception: exception,
            onRetry: _cubit.load,
          ),
          DataSuccess(:final data) => _YearBody(
            data: data,
            onMonthTap: _openMonth,
          ),
        },
      ),
    );
  }
}

class _YearBody extends StatelessWidget {
  const _YearBody({
    required this.data,
    required this.onMonthTap,
  });

  final YearReportModel data;
  final ValueChanged<MonthCardModel> onMonthTap;

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
          eyebrow: l10n.managerReportsHeaderYear,
          title: '${data.year}',
        ),
        const SizedBox(height: AppSpacing.x3),
        ManagerReportSummaryCard(
          title: l10n.managerReportsSummaryEarnedYear,
          revenue: data.summary.revenue,
          currency: data.summary.currency,
          sessions: data.summary.sessions,
          shiftSeconds: data.summary.shiftSeconds,
        ),
        const SizedBox(height: AppSpacing.x4),
        _MonthGrid(months: data.months, onTap: onMonthTap),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.months,
    required this.onTap,
  });

  final List<MonthCardModel> months;
  final ValueChanged<MonthCardModel> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: months.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.x2,
        crossAxisSpacing: AppSpacing.x2,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (_, i) {
        return ManagerReportMonthCard(
          months[i],
          onTap: onTap,
        );
      },
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
