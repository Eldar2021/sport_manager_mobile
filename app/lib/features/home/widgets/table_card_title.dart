import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TableCardTitle extends StatelessWidget {
  const TableCardTitle(this.table, {super.key});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    final occupied = table.isOccupied;
    final label = table.name ?? table.description;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.homeTableTitle(table.number),
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: AppSpacing.x1),
          StatusDot(
            color: occupied ? context.colors.error : context.appColors.success,
            pulse: occupied,
          ),
        ],
      ),
      subtitle: label != null && label.isNotEmpty
          ? Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
    );
  }
}
