import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Orange gradient summary card shown above every period list. Caller
/// passes a localized title (e.g. "ЗАРАБОТАНО ЗА ДЕНЬ") plus the totals.
class ManagerReportSummaryCard extends StatelessWidget {
  const ManagerReportSummaryCard({
    required this.title,
    required this.revenue,
    required this.currency,
    required this.sessions,
    required this.shiftSeconds,
    super.key,
  });

  final String title;
  final int revenue;
  final Currency currency;
  final int sessions;
  final int shiftSeconds;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onAmber = context.colors.onPrimary;

    return ClipRRect(
      borderRadius: AppRadius.cardBorderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.cardBorderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colors.primary,
              AppColors.brandAmberDark,
            ],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -40,
              right: -40,
              child: _DecorativeCircle(size: 160, opacity: 0.10),
            ),
            const Positioned(
              top: 20,
              right: -70,
              child: _DecorativeCircle(size: 130, opacity: 0.06),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: onAmber.withValues(alpha: 0.85),
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  _AmountRow(amount: revenue, currency: currency),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCell(
                          label: l10n.managerReportsSummarySessions,
                          value: ManagerReportFormat.amount(sessions),
                        ),
                      ),
                      Expanded(
                        child: _MetricCell(
                          label: l10n.managerReportsSummaryOnShift,
                          value: ManagerReportFormat.duration(shiftSeconds, l10n),
                        ),
                      ),
                    ],
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

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.amount,
    required this.currency,
  });

  final int amount;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onAmber = context.colors.onPrimary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            ManagerReportFormat.amount(amount),
            style: context.textTheme.displaySmall?.copyWith(
              color: onAmber,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          ManagerReportFormat.currencySuffix(currency, l10n),
          style: context.textTheme.titleMedium?.copyWith(
            color: onAmber.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final onAmber = context.colors.onPrimary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: onAmber.withValues(alpha: 0.80),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            color: onAmber,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({
    required this.size,
    required this.opacity,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
