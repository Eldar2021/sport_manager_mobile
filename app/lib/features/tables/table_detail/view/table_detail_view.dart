import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';

class TableDetailView extends StatefulWidget {
  const TableDetailView(this.table, {super.key});

  final TableModel table;

  @override
  State<TableDetailView> createState() => _TableDetailViewState();
}

class _TableDetailViewState extends State<TableDetailView> {
  late final TableDetailCubit _tableCubit;

  @override
  void initState() {
    super.initState();
    _tableCubit = TableDetailCubit(
      table: widget.table,
      sessionRepository: GetIt.I<SessionRepository>(),
      facilityRepository: GetIt.I<FacilityRepository>(),
    );
  }

  @override
  void dispose() {
    _tableCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableDetailCubit, TableDetailState>(
      bloc: _tableCubit,
      buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      builder: (context, state) => switch (state) {
        TableDetailFree() => FreeTableView(
          tableCubit: _tableCubit,
          table: widget.table,
        ),
        TableDetailOccupied(:final table, :final session) => OccupiedTableView(
          tableCubit: _tableCubit,
          table: table,
          session: session,
        ),
      },
    );
  }
}
