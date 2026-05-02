import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ManagerSessionLog extends StatelessWidget {
  const ManagerSessionLog({
    required this.cubit,
    required this.entries,
    super.key,
  });

  final ManagerReportDetailCubit cubit;
  final List<ManagerSessionLogEntry> entries;

  Iterable<ManagerSessionLogEntry> _filtered(ManagerLogFilter f) {
    return switch (f) {
      ManagerLogFilter.all => entries,
      ManagerLogFilter.cancelled => entries.where((e) => e.isCancelled),
      ManagerLogFilter.discounted => entries.where((e) => e.hadDiscount),
      ManagerLogFilter.short => entries.where((e) => e.isShort),
    };
  }

  String _filterLabel(ManagerLogFilter f, AppLocalizations l10n) {
    return switch (f) {
      ManagerLogFilter.all => l10n.reportsLogFilterAll,
      ManagerLogFilter.cancelled => l10n.reportsLogFilterCancelled,
      ManagerLogFilter.discounted => l10n.reportsLogFilterDiscounted,
      ManagerLogFilter.short => l10n.reportsLogFilterShort,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reportsSessionLogTitle,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        BlocBuilder<ManagerReportDetailCubit, ManagerReportDetailState>(
          bloc: cubit,
          buildWhen: (a, b) => a.logFilter != b.logFilter,
          builder: (_, state) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final f in ManagerLogFilter.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.x2),
                      child: ChoiceChip(
                        label: Text(_filterLabel(f, l10n)),
                        selected: state.logFilter == f,
                        onSelected: (_) => cubit.changeLogFilter(f),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.x2),
        BlocBuilder<ManagerReportDetailCubit, ManagerReportDetailState>(
          bloc: cubit,
          buildWhen: (a, b) => a.logFilter != b.logFilter,
          builder: (_, state) {
            final list = _filtered(state.logFilter).toList(growable: false);
            if (list.isEmpty) {
              return Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Center(child: Text(l10n.reportsLogEmpty)),
                ),
              );
            }
            return Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < list.length; i++) ...[
                    if (i != 0) const Divider(height: 1),
                    _LogRow(list[i]),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow(this.entry);

  final ManagerSessionLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final df = DateFormat('dd.MM HH:mm', Localizations.localeOf(context).languageCode);
    final tableLabel = entry.tableName == null || entry.tableName!.isEmpty
        ? '${l10n.reportsTableLabel} ${entry.tableNumber}'
        : '${l10n.reportsTableLabel} ${entry.tableNumber} · «${entry.tableName}»';
    return ListTile(
      leading: Icon(
        entry.isCancelled ? Icons.cancel_outlined : Icons.check_circle_outline,
        color: entry.isCancelled ? context.colors.error : context.appColors.success,
      ),
      title: Text(
        tableLabel,
        style: context.textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${entry.venueName} · ${df.format(entry.startedAt)}'
        '${entry.durationSeconds != null ? ' · ${ReportFormat.duration(entry.durationSeconds!)}' : ''}'
        '${entry.hadDiscount ? ' · -${entry.discountPercent}%' : ''}',
        style: context.appTextStyles.muted.labelSmall,
      ),
      trailing: entry.isCancelled
          ? Icon(Icons.block, size: 18, color: context.colors.error)
          : Text(
              ReportFormat.money(entry.totalAmount ?? 0, entry.currency),
              style: context.textTheme.bodyMedium,
            ),
    );
  }
}
