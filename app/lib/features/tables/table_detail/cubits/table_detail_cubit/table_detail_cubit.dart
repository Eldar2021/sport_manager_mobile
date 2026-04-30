import 'dart:async';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';

part 'table_detail_state.dart';

class TableDetailCubit extends Cubit<TableDetailState> {
  TableDetailCubit({
    required TableModel table,
    required SessionRepository repository,
  }) : _repo = repository,
       super(TableDetailFree(table: table)) {
    if (table.session != null) {
      _mountSession(table, table.session!);
    }
  }

  final SessionRepository _repo;
  SessionActiveCubit? _sessionCubit;
  StreamSubscription<SessionActiveState>? _sessionSub;

  Future<void> startSession() async {
    if (state is! TableDetailFree) return;
    final s = state as TableDetailFree;
    emit(s.copyWith(startStatus: const RequestLoading()));
    try {
      final session = await _repo.startSession(s.table.id);
      _mountSession(s.table, session);
    } on Object catch (e) {
      emit(s.copyWith(startStatus: RequestFailure(e)));
    }
  }

  void _mountSession(
    TableModel table,
    SessionModel session,
  ) {
    _clearSession();
    final cubit = SessionActiveCubit(
      session: session,
      repository: _repo,
    );
    _sessionSub = cubit.stream.listen(_onSessionEvent);
    _sessionCubit = cubit;
    emit(
      TableDetailOccupied(
        table: table,
        sessionCubit: cubit,
      ),
    );
  }

  void _onSessionEvent(SessionActiveState sessionState) {
    if (sessionState.stopStatus.isSuccess || sessionState.cancelStatus.isSuccess) {
      final table = (state as TableDetailOccupied).table;
      _clearSession();
      emit(TableDetailFree(table: table));
    }
  }

  void _clearSession() {
    _sessionSub?.cancel();
    _sessionCubit?.close();
    _sessionSub = null;
    _sessionCubit = null;
  }

  @override
  Future<void> close() {
    _clearSession();
    return super.close();
  }
}
