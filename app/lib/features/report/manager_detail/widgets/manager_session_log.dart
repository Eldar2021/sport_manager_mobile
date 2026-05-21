import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Filterable list of a manager's recent sessions. MVP: only "All" and
/// "Cancelled" filters; no discount/short-cluster filters since those
/// were the entry point to the fraud-signal flow that's been removed.
class ManagerSessionLog extends StatefulWidget {
  const ManagerSessionLog({
    required this.cubit,
    required this.entries,
    super.key,
  });

  final ManagerReportDetailCubit cubit;
  final List<ManagerSessionLogEntry> entries;

  @override
  State<ManagerSessionLog> createState() => _ManagerSessionLogState();
}

class _ManagerSessionLogState extends State<ManagerSessionLog> with SingleTickerProviderStateMixin {
  static const List<ManagerLogFilter> _filters = ManagerLogFilter.values;

  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: _filters.length,
      vsync: this,
      initialIndex: _filters.indexOf(widget.cubit.state.logFilter),
    );
    _controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_controller.indexIsChanging) return;
    widget.cubit.changeLogFilter(_filters[_controller.index]);
  }

  Iterable<ManagerSessionLogEntry> _filtered(ManagerLogFilter f) {
    return switch (f) {
      ManagerLogFilter.all => widget.entries,
      ManagerLogFilter.cancelled => widget.entries.where((e) => e.isCancelled),
    };
  }

  String _filterLabel(ManagerLogFilter f, AppLocalizations l10n) {
    return switch (f) {
      ManagerLogFilter.all => l10n.reportsLogFilterAll,
      ManagerLogFilter.cancelled => l10n.reportsLogFilterCancelled,
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
        AppPillTabBar(
          controller: _controller,
          tabs: [
            for (final f in _filters) Tab(text: _filterLabel(f, l10n)),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        BlocBuilder<ManagerReportDetailCubit, ManagerReportDetailState>(
          bloc: widget.cubit,
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
    final (leadingIcon, leadingColor) = switch (entry.status) {
      ManagerSessionLogStatus.active => (Icons.timelapse_outlined, context.colors.primary),
      ManagerSessionLogStatus.completed => (Icons.check_circle_outline, context.appColors.success),
      ManagerSessionLogStatus.cancelled => (Icons.cancel_outlined, context.colors.error),
    };
    return ListTile(
      leading: Icon(leadingIcon, color: leadingColor),
      title: Text(
        tableLabel,
        style: context.textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${df.format(entry.startedAt)}'
        '${entry.durationSeconds != null ? ' · ${ReportFormat.duration(entry.durationSeconds!)}' : ''}'
        '${entry.customerName != null && entry.customerName!.isNotEmpty ? ' · ${entry.customerName}' : ''}',
        style: context.appTextStyles.muted.labelSmall,
      ),
      trailing: switch (entry.status) {
        ManagerSessionLogStatus.active => Text(
          l10n.reportsLogStatusActive,
          style: context.appTextStyles.muted.labelSmall,
        ),
        ManagerSessionLogStatus.completed => Text(
          ReportFormat.money(entry.totalAmount ?? 0, entry.currency),
          style: context.textTheme.bodyMedium,
        ),
        ManagerSessionLogStatus.cancelled => Icon(Icons.block, size: 18, color: context.colors.error),
      },
    );
  }
}
