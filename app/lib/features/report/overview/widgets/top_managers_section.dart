import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Managers working at the currently-selected venue, sorted by revenue
/// they've generated. MVP scope: no risk signals — tapping a row opens
/// the manager-detail page with KPI band + session log.
class TopManagersSection extends StatelessWidget {
  const TopManagersSection(this.cubit, {super.key});

  final ReportOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reportsTopManagersTitle,
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.x2),
        BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
          bloc: cubit,
          buildWhen: (a, b) => a.managers != b.managers,
          builder: (_, state) => switch (state.managers) {
            RequestInitial<List<ManagerReportRowModel>>() ||
            RequestLoading<List<ManagerReportRowModel>>() => const _ManagersSkeleton(),
            RequestFailure<List<ManagerReportRowModel>>() => _MessageCard(l10n.reportsErrorTitle),
            RequestSuccess<List<ManagerReportRowModel>>(:final data) when data.isEmpty => _MessageCard(
              l10n.reportsEmptySubtitle,
            ),
            RequestSuccess<List<ManagerReportRowModel>>(:final data) => Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < data.length; i++) ...[
                    if (i != 0) const Divider(height: 1),
                    _ManagerRow(data[i]),
                  ],
                ],
              ),
            ),
          },
        ),
      ],
    );
  }
}

class _ManagerRow extends StatelessWidget {
  const _ManagerRow(this.row);

  final ManagerReportRowModel row;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      onTap: () => context.push('${AppRoutes.report}/managers/${row.managerId}'),
      leading: CircleAvatar(
        backgroundColor: context.colors.primaryContainer,
        child: Text(
          _initials(row.name),
          style: TextStyle(color: context.colors.onPrimaryContainer),
        ),
      ),
      title: Text(
        row.name,
        style: context.textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${ReportFormat.money(row.revenue, row.currency)} · '
        '${row.sessions} ${l10n.reportsSessionsShort}',
        style: context.appTextStyles.muted.labelSmall,
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts.first.isNotEmpty && parts.last.isNotEmpty) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }
}

class _ManagersSkeleton extends StatelessWidget {
  const _ManagersSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.x3),
        child: Column(
          children: [
            ShimmerBox(height: 18),
            SizedBox(height: AppSpacing.x3),
            ShimmerBox(height: 18),
            SizedBox(height: AppSpacing.x3),
            ShimmerBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Center(child: Text(message)),
      ),
    );
  }
}
