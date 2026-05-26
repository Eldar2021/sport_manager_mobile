import 'package:flutter/material.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/features/manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// One day row in the week / month list. Renders two shapes depending on
/// `day.isDayOff`:
///   - regular day: amount + sessions count + shift time, tappable (chevron)
///   - rest day:    grey day badge + "Выходной" centered, **not** tappable
class ManagerReportDayTile extends StatelessWidget {
  const ManagerReportDayTile(
    this.day, {
    required this.onTap,
    super.key,
  });

  final DayCardModel day;
  final ValueChanged<DayCardModel> onTap;

  @override
  Widget build(BuildContext context) {
    if (day.isDayOff) return _RestDayCard(day: day);

    final l10n = context.l10n;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: AppRadius.cardBorderRadius,
        onTap: () => onTap(day),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x3,
          ),
          child: Row(
            children: [
              _DayBadge(day: day),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          ManagerReportFormat.amount(day.revenue),
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Text(
                          ManagerReportFormat.currencySuffix(day.currency, l10n),
                          style: context.appTextStyles.muted.labelMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${l10n.managerReportsSessionsCount(day.sessions)} · ${ManagerReportFormat.duration(day.shiftSeconds, l10n)}',
                      style: context.appTextStyles.muted.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestDayCard extends StatelessWidget {
  const _RestDayCard({required this.day});

  final DayCardModel day;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final faded = context.colors.onSurfaceVariant;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            _DayBadge(day: day, muted: true),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                l10n.managerReportsDayOff,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: faded,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  const _DayBadge({
    required this.day,
    this.muted = false,
  });

  final DayCardModel day;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bg = muted ? context.colors.surfaceContainerHighest : context.colors.surfaceContainer;
    final fg = muted ? context.colors.onSurfaceVariant : context.colors.onSurface;

    return SizedBox(
      width: 40,
      height: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.buttonBorderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.dayOfMonth}',
              style: context.textTheme.titleMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ManagerReportFormat.dayOfWeekShort(day.shortDayOfWeek, l10n),
              style: context.textTheme.labelSmall?.copyWith(
                color: fg.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
