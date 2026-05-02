import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Single KPI tile with title, big value, and optional delta vs previous
/// period. Caller passes the value already formatted.
class ReportKpiCard extends StatelessWidget {
  const ReportKpiCard({
    required this.title,
    required this.value,
    this.subtitle,
    this.deltaPercent,
    super.key,
  });

  final String title;
  final String value;
  final String? subtitle;

  /// `null` → no delta row. `0` → renders "0%".
  final int? deltaPercent;

  Color _deltaColor(BuildContext context) {
    final v = deltaPercent;
    if (v == null || v == 0) return context.colors.onSurfaceVariant;
    if (v > 0) return context.appColors.success;
    return context.colors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.appTextStyles.muted.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              value,
              style: context.textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null || deltaPercent != null) ...[
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  if (deltaPercent != null) ...[
                    Icon(
                      deltaPercent! > 0
                          ? Icons.trending_up_rounded
                          : deltaPercent! < 0
                          ? Icons.trending_down_rounded
                          : Icons.trending_flat_rounded,
                      size: 16,
                      color: _deltaColor(context),
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      ReportFormat.delta(deltaPercent),
                      style: context.textTheme.labelMedium?.copyWith(
                        color: _deltaColor(context),
                      ),
                    ),
                  ],
                  if (subtitle != null) ...[
                    if (deltaPercent != null) const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        subtitle!,
                        style: context.appTextStyles.muted.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
