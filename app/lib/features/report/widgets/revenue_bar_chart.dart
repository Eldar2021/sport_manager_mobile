import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Lightweight day-by-day revenue bar chart. Bars rendered as `Container`s
/// inside a `Row` — no extra chart dependency needed for the current
/// requirements. Highest bar in the period is highlighted with the
/// primary color, the rest use a softer tone.
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
        height: 140,
        child: Center(
          child: Text(
            '—',
            style: context.appTextStyles.muted.bodyMedium,
          ),
        ),
      );
    }
    final maxValue = points.fold<int>(0, (m, p) => p.revenue > m ? p.revenue : m);
    final peakIdx = points.indexWhere((p) => p.revenue == maxValue);

    return SizedBox(
      height: 140,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Horizontal scroll only when the bars wouldn't fit at min 6dp width.
          final minWidth = points.length * 8.0;
          final fits = minWidth <= constraints.maxWidth;
          final content = Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < points.length; i++)
                Expanded(
                  child: _Bar(
                    point: points[i],
                    maxValue: maxValue == 0 ? 1 : maxValue,
                    isPeak: i == peakIdx,
                    currency: currency,
                  ),
                ),
            ],
          );
          if (fits) return content;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: constraints.maxWidth,
              child: content,
            ),
          );
        },
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.point,
    required this.maxValue,
    required this.isPeak,
    required this.currency,
  });

  final RevenuePointModel point;
  final int maxValue;
  final bool isPeak;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final ratio = (point.revenue / maxValue).clamp(0.0, 1.0);
    final color = isPeak ? context.colors.primary : context.appColors.brandAmberSoft;
    return Tooltip(
      message: ReportFormat.money(point.revenue, currency),
      preferBelow: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: ratio == 0 ? 0.02 : ratio,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
