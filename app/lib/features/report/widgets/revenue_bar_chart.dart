import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Day-by-day revenue column chart, rendered with `SfCartesianChart`. The
/// peak day uses [ColorScheme.primary]; the rest use a softer brand-amber
/// tint so the highest-grossing day pops at a glance.
class RevenueBarChart extends StatelessWidget {
  const RevenueBarChart({
    required this.points,
    required this.currency,
    super.key,
  });

  final List<RevenuePointModel> points;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            '—',
            style: context.appTextStyles.muted.bodyMedium,
          ),
        ),
      );
    }
    final maxValue = points.fold<int>(
      0,
      (m, p) => p.revenue > m ? p.revenue : m,
    );
    final peakBucket = points.firstWhere((p) => p.revenue == maxValue).bucket;
    final locale = Localizations.localeOf(context).languageCode;
    final dayLabel = DateFormat.MMMd(locale);

    return SizedBox(
      height: 160,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          intervalType: DateTimeIntervalType.days,
          dateFormat: dayLabel,
          labelStyle: context.appTextStyles.muted.labelSmall,
        ),
        primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          labelStyle: context.appTextStyles.muted.labelSmall,
          numberFormat: NumberFormat.compact(locale: locale),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x · point.y',
          header: '',
        ),
        series: <CartesianSeries<RevenuePointModel, DateTime>>[
          ColumnSeries<RevenuePointModel, DateTime>(
            dataSource: points,
            xValueMapper: (p, _) => p.bucket,
            yValueMapper: (p, _) => p.revenue,
            pointColorMapper: (p, _) =>
                p.bucket == peakBucket ? context.colors.primary : context.appColors.brandAmberSoft,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            spacing: 0.1,
          ),
        ],
      ),
    );
  }
}
