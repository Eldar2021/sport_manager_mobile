import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Single row of the spots section — spot label, optional trend delta,
/// total revenue and a relative-progress bar. Built on [ListTile] so tap
/// ripple, padding and theming come from the existing list-tile theme.
class SpotsRow extends StatelessWidget {
  const SpotsRow({
    required this.row,
    required this.maxRevenue,
    required this.spotLabel,
    super.key,
  });

  final SpotReportRowModel row;
  final String spotLabel;

  /// The largest revenue among the visible rows; used to scale the
  /// relative-progress bar.
  final int maxRevenue;

  @override
  Widget build(BuildContext context) {
    final ratio = (row.revenue / maxRevenue).clamp(0.0, 1.0);
    final delta = row.deltaPercent;
    final deltaColor = delta == null ? null : (delta > 0 ? context.appColors.success : context.colors.error);
    return ListTile(
      onTap: () => context.push('${AppRoutes.report}/spots/${row.spotId}/${row.venueId}'),
      title: Row(
        children: [
          Expanded(
            child: Text(
              _label(row),
              style: context.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (delta != null) ...[
            Icon(
              delta > 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: 14,
              color: deltaColor,
            ),
            const SizedBox(width: 2),
            Text(
              ReportFormat.delta(delta),
              style: context.textTheme.labelSmall?.copyWith(color: deltaColor),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
          Text(
            ReportFormat.money(row.revenue, row.currency),
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
      subtitle: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: LinearProgressIndicator(
          value: ratio,
          minHeight: 4,
          backgroundColor: context.colors.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
        ),
      ),
    );
  }

  String _label(SpotReportRowModel r) {
    final base = '$spotLabel ${r.spotNumber}';
    if (r.spotName != null && r.spotName!.isNotEmpty) {
      return '$base · «${r.spotName}»';
    }
    return base;
  }
}
