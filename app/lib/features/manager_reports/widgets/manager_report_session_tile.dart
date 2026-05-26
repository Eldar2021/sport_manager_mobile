import 'package:flutter/material.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/features/manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// One completed session row — used in TODAY and Day detail. Non-interactive
/// in v1; design has no session-detail screen.
class ManagerReportSessionTile extends StatelessWidget {
  const ManagerReportSessionTile(this.session, {super.key});

  final SessionCardModel session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final productsAmount = session.productsAmount;
    final timeRange =
        '${ManagerReportFormat.timeOfDay(session.startedAt)} →'
        ' ${ManagerReportFormat.timeOfDay(session.endedAt)}';
    final duration = ManagerReportFormat.duration(session.durationSeconds, l10n);
    final spotTitle = session.spotName ?? l10n.homeSpotTitle(session.venueType.spotLabel(context), session.spotNumber);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            const _SpotIcon(),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        spotTitle,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Flexible(
                        child: Text(
                          '«${session.venueName}»',
                          style: context.appTextStyles.muted.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '$timeRange · $duration',
                    style: context.appTextStyles.muted.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            _AmountColumn(
              total: session.totalAmount,
              currency: ManagerReportFormat.currencySuffix(
                session.currency,
                l10n,
              ),
              productsAmount: productsAmount,
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotIcon extends StatelessWidget {
  const _SpotIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Align(
          child: Icon(
            Icons.sports_baseball_outlined,
            size: 18,
            color: context.colors.primary,
          ),
        ),
      ),
    );
  }
}

class _AmountColumn extends StatelessWidget {
  const _AmountColumn({
    required this.total,
    required this.currency,
    required this.productsAmount,
  });

  final int total;
  final String currency;
  final int productsAmount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              ManagerReportFormat.amount(total),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              currency,
              style: context.appTextStyles.muted.labelMedium,
            ),
          ],
        ),
        if (productsAmount > 0) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            l10n.managerReportsProductsBadge(
              ManagerReportFormat.amount(productsAmount),
            ),
            style: context.appTextStyles.muted.labelSmall,
          ),
        ],
      ],
    );
  }
}
