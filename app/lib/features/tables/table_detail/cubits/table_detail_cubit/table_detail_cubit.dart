import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'table_detail_state.dart';

class TableDetailCubit extends Cubit<TableDetailState> {
  TableDetailCubit({
    required TableModel table,
    required SessionRepository repository,
  }) : _repo = repository,
       super(
         table.session != null
             ? TableDetailOccupied(
                 table: table,
                 session: table.session!,
               )
             : TableDetailFree(table: table),
       );

  final SessionRepository _repo;

  Future<void> startSession() async {
    if (state is! TableDetailFree) return;
    final s = state as TableDetailFree;
    emit(s.copyWith(startStatus: const RequestLoading()));
    try {
      final session = await _repo.startSession(s.table.id);
      emit(TableDetailOccupied(table: s.table, session: session));
    } on Object catch (e) {
      emit(s.copyWith(startStatus: RequestFailure(e)));
    }
  }

  void onSessionEnded() {
    if (state is! TableDetailOccupied) return;
    final table = (state as TableDetailOccupied).table;
    emit(TableDetailFree(table: table));
  }
}
