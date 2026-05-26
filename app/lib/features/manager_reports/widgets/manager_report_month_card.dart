import 'package:flutter/material.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/features/manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// One month card in the year grid. Three visual states driven by the
/// model:
///   - regular past month → solid card, progress bar, tappable
///   - current month (`isCurrent`) → amber border + "СЕЙЧАС" badge, tappable
///   - future month (`isFuture`) → faded, no totals, **not** tappable
class ManagerReportMonthCard extends StatelessWidget {
  const ManagerReportMonthCard(
    this.month, {
    required this.onTap,
    super.key,
  });

  final MonthCardModel month;
  final ValueChanged<MonthCardModel> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isFuture = month.isFuture;
    final isCurrent = month.isCurrent;

    final borderColor = isCurrent ? context.colors.primary : Colors.transparent;
    final cardColor = isCurrent ? context.colors.primaryContainer.withValues(alpha: 0.35) : context.colors.surface;

    return Card(
      margin: EdgeInsets.zero,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardBorderRadius,
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      child: InkWell(
        borderRadius: AppRadius.cardBorderRadius,
        onTap: isFuture ? null : () => onTap(month),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    ManagerReportFormat.monthShort(month.monthShort, l10n),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isFuture ? context.colors.onSurfaceVariant : context.colors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (isCurrent) const _NowBadge(),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              if (isFuture)
                Text(
                  '—',
                  style: context.appTextStyles.muted.titleLarge,
                )
              else
                _MonthBody(month: month),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthBody extends StatelessWidget {
  const _MonthBody({required this.month});

  final MonthCardModel month;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                ManagerReportFormat.amount(month.revenue),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              ManagerReportFormat.currencySuffix(month.currency, l10n),
              style: context.appTextStyles.muted.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        _ProgressBar(ratio: month.progressRatio),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            Text(
              '${month.sessions} ${l10n.managerReportsSessionsAbbr}',
              style: context.appTextStyles.muted.labelSmall,
            ),
            const Spacer(),
            Text(
              ManagerReportFormat.duration(month.shiftSeconds, l10n),
              style: context.appTextStyles.muted.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.ratio});

  final double ratio;

  @override
  Widget build(BuildContext context) {
    final clamped = ratio.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: SizedBox(
        height: 4,
        child: LinearProgressIndicator(
          value: clamped,
          backgroundColor: context.colors.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
        ),
      ),
    );
  }
}

class _NowBadge extends StatelessWidget {
  const _NowBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: AppRadius.chipBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: 2,
        ),
        child: Text(
          context.l10n.managerReportsNowBadge,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colors.onPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
