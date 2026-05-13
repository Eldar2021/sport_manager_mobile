import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'table_detail_state.dart';

class TableDetailCubit extends Cubit<TableDetailState> {
  TableDetailCubit({
    required TableModel table,
    required SessionRepository sessionRepository,
    required FacilityRepository facilityRepository,
  }) : _sessionRepo = sessionRepository,
       _facilityRepo = facilityRepository,
       super(
         table.session != null
             ? TableDetailOccupied(table: table, session: table.session!)
             : TableDetailFree(table: table),
       );

  final SessionRepository _sessionRepo;
  final FacilityRepository _facilityRepo;

  Future<void> startSession() async {
    if (state is! TableDetailFree) return;
    final s = state as TableDetailFree;
    emit(s.copyWith(startStatus: const RequestLoading()));
    try {
      final session = await _sessionRepo.startSession(s.table.id);
      emit(TableDetailOccupied(table: s.table, session: session));
    } on Object catch (e) {
      emit(s.copyWith(startStatus: RequestFailure(e)));
    }
  }

  void updateTable(TableModel updated) {
    emit(
      switch (state) {
        final TableDetailFree s => s.copyWith(table: updated),
        final TableDetailOccupied s => s.copyWith(table: updated),
      },
    );
  }

  void onSessionEnded() {
    if (state is! TableDetailOccupied) return;
    final table = (state as TableDetailOccupied).table;
    emit(TableDetailFree(table: table));
  }

  Future<void> deleteTable() async {
    final tableId = switch (state) {
      TableDetailFree(:final table) => table.id,
      TableDetailOccupied(:final table) => table.id,
    };
    _emitDeleteStatus(const RequestLoading());
    try {
      await _facilityRepo.deleteTable(tableId);
      _emitDeleteStatus(const RequestSuccess(true));
    } on Object catch (e) {
      _emitDeleteStatus(RequestFailure(e));
    }
  }

  void _emitDeleteStatus(RequestStatus<bool> status) {
    emit(
      switch (state) {
        final TableDetailFree s => s.copyWith(deleteStatus: status),
        final TableDetailOccupied s => s.copyWith(deleteStatus: status),
      },
    );
  }
}
