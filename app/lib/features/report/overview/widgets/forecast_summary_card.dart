import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ForecastSummaryCard extends StatelessWidget {
  const ForecastSummaryCard(this.cubit, {super.key});

  final ReportOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
      bloc: cubit,
      buildWhen: (a, b) => a.forecast != b.forecast || a.filter != b.filter,
      builder: (_, state) => switch (state.forecast) {
        RequestSuccess<ForecastModel>(:final data) when data.points.isNotEmpty => _Body(
          forecast: data,
          filter: state.filter,
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.forecast,
    required this.filter,
  });

  final ForecastModel forecast;
  final ReportFilter filter;

  Color _deltaColor(BuildContext context, int? delta) {
    if (delta == null) return context.colors.onSurfaceVariant;
    return delta > 0 ? context.appColors.success : context.colors.error;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final delta = forecast.deltaPercent;
    final deltaColor = _deltaColor(context, delta);
    final prevRange = filter.previousCalendarRange ?? filter.range.previous;
    final prevLabel = ReportFormat.rangeLabel(prevRange, filter.period, locale);
    return Card(
      margin: EdgeInsets.zero,
      color: context.colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_graph_rounded,
                  color: context.colors.onPrimaryContainer,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  l10n.reportsForecastSummaryTitle,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              ReportFormat.money(forecast.projectedTotal, forecast.currency),
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            if (delta != null)
              Row(
                children: [
                  Icon(
                    delta > 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    color: deltaColor,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Expanded(
                    child: Text(
                      '${ReportFormat.delta(delta)} ${l10n.reportsForecastVsRange(prevLabel)}',
                      style: context.textTheme.bodyMedium?.copyWith(color: deltaColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else
              Text(
                l10n.reportsForecastNoComparison,
                style: context.appTextStyles.muted.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
