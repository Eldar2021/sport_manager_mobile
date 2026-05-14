import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Single row of the tables section — table label, optional trend delta,
/// total revenue and a relative-progress bar. Built on [ListTile] so tap
/// ripple, padding and theming come from the existing list-tile theme.
class TablesRow extends StatelessWidget {
  const TablesRow({
    required this.row,
    required this.maxRevenue,
    super.key,
  });

  final TableReportRowModel row;

  /// The largest revenue among the visible rows; used to scale the
  /// relative-progress bar.
  final int maxRevenue;

  @override
  Widget build(BuildContext context) {
    final ratio = (row.revenue / maxRevenue).clamp(0.0, 1.0);
    final delta = row.deltaPercent;
    final deltaColor = delta == null ? null : (delta > 0 ? context.appColors.success : context.colors.error);
    return ListTile(
      onTap: () => context.push('${AppRoutes.report}/tables/${row.tableId}/${row.venueId}'),
      title: Row(
        children: [
          Expanded(
            child: Text(
              _label(row, context.l10n),
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

  String _label(TableReportRowModel r, AppLocalizations l10n) {
    final base = '${l10n.reportsTableLabel} ${r.tableNumber}';
    if (r.tableName != null && r.tableName!.isNotEmpty) {
      return '$base · «${r.tableName}»';
    }
    return base;
  }
}
