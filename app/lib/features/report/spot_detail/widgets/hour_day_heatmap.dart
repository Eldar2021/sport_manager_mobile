import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/report/utils/report_format.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Visualises a `7×24` revenue intensity matrix as a colour-coded grid.
/// Rows = ISO weekdays (1=Mon … 7=Sun), columns = hours of the day.
class HourDayHeatmap extends StatelessWidget {
  const HourDayHeatmap(this.heatmap, {super.key});

  final List<List<int>> heatmap;

  @override
  Widget build(BuildContext context) {
    if (heatmap.length != 7 || heatmap.any((r) => r.length != 24)) {
      return const SizedBox.shrink();
    }
    final maxValue = heatmap.fold<int>(
      0,
      (m, row) => row.fold<int>(m, (rm, v) => v > rm ? v : rm),
    );
    final base = context.colors.primary;
    final locale = Localizations.localeOf(context).languageCode;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row — hours every 3rd column to keep it readable.
            Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Row(
                    children: List.generate(24, (h) {
                      return Expanded(
                        child: Text(
                          h % 3 == 0 ? '$h' : '',
                          textAlign: TextAlign.center,
                          style: context.appTextStyles.muted.labelSmall,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x1),
            for (var d = 0; d < 7; d++)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text(
                        ReportFormat.weekdayShort(d + 1, locale),
                        style: context.appTextStyles.muted.labelSmall,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          for (var h = 0; h < 24; h++)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0.5),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: maxValue == 0
                                          ? context.colors.surfaceContainerHighest
                                          : base.withValues(alpha: heatmap[d][h] / maxValue * 0.95),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
