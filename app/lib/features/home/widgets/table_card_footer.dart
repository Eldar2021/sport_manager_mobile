import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TableCardFooter extends StatelessWidget {
  const TableCardFooter(this.table, {super.key});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    final rate =
        '${table.tarifAmount} ${table.currency.localizedName(context.l10n).toLowerCase()}'
        ' ${table.tarifType.localizedUnit(context.l10n).toLowerCase()}';
    if (table.isOccupied) {
      final isPaused = table.session!.isPaused;
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        minTileHeight: 0,
        title: SessionTimer(table.session!),
        subtitle: Text(
          isPaused ? context.l10n.homeTablePaused : context.l10n.homeTableOccupied,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 0,
      title: Text(
        context.l10n.homeTableFree,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.appColors.success,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        rate,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
