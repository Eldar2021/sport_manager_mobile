import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/report/overview/cubit/report_overview_cubit.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class InsightsStrip extends StatelessWidget {
  const InsightsStrip({required this.cubit, super.key});

  final ReportOverviewCubit cubit;

  void _handleAction(BuildContext context, InsightAction action) {
    switch (action.type) {
      case InsightActionType.managerDetail:
        if (action.targetId != null) {
          context.push('${AppRoutes.report}/managers/${action.targetId}');
        }
      case InsightActionType.tableDetail:
        if (action.targetId != null) {
          context.push('${AppRoutes.report}/tables/${action.targetId}');
        }
      case InsightActionType.venueDetail:
      case InsightActionType.forecast:
      case InsightActionType.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
      bloc: cubit,
      buildWhen: (a, b) => a.insights != b.insights,
      builder: (_, state) {
        return switch (state.insights) {
          RequestSuccess<List<InsightModel>>(:final data) when data.isNotEmpty => SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              itemCount: data.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x3),
              itemBuilder: (_, i) {
                final insight = data[i];
                return _InsightCard(
                  insight: insight,
                  onTap: () {
                    if (insight.action != null) _handleAction(context, insight.action!);
                  },
                  onDismiss: () => cubit.dismissInsight(insight.id),
                );
              },
            ),
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.insight,
    required this.onTap,
    required this.onDismiss,
  });

  final InsightModel insight;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final (bg, fg) = switch (insight.severity) {
      InsightSeverity.critical => (context.colors.errorContainer, context.colors.onErrorContainer),
      InsightSeverity.warning => (context.appColors.warningContainer, context.appColors.onWarning),
      InsightSeverity.info => (context.appColors.infoContainer, context.appColors.info),
    };
    return SizedBox(
      width: 280,
      child: Card(
        color: bg,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.cardBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(_iconFor(insight.severity), color: fg, size: 20),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        insight.titleMessage.getMessage(locale),
                        style: context.textTheme.labelLarge?.copyWith(color: fg),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: onDismiss,
                      borderRadius: BorderRadius.circular(99),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(Icons.close, size: 16, color: fg),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Expanded(
                  child: Text(
                    insight.bodyMessage.getMessage(locale),
                    style: context.textTheme.bodySmall?.copyWith(color: fg),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(InsightSeverity s) {
    return switch (s) {
      InsightSeverity.critical => Icons.error_outline_rounded,
      InsightSeverity.warning => Icons.warning_amber_rounded,
      InsightSeverity.info => Icons.info_outline_rounded,
    };
  }
}
