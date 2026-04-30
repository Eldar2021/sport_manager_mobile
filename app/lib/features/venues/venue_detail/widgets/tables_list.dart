import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';

class TablesList extends StatelessWidget {
  const TablesList({
    required this.tables,
    required this.venueId,
    super.key,
  });

  final List<TableModel> tables;
  final String venueId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: tables.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final table = tables[index];
        return VenueTableTile(
          key: ValueKey(table.id),
          table: table,
          onTap: () => context.push(
            AppRoutes.tableForm,
            extra: TableFormExtra(venueId: venueId, table: table),
          ),
        );
      },
    );
  }
}
