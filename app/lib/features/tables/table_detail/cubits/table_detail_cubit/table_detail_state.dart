part of 'table_detail_cubit.dart';

sealed class TableDetailState extends Equatable {
  const TableDetailState();
}

@immutable
final class TableDetailFree extends TableDetailState {
  const TableDetailFree({
    required this.table,
    this.startStatus = const RequestInitial(),
    this.deleteStatus = const RequestInitial(),
  });

  final TableModel table;
  final RequestStatus<SessionModel> startStatus;
  final RequestStatus<bool> deleteStatus;

  TableDetailFree copyWith({
    TableModel? table,
    RequestStatus<SessionModel>? startStatus,
    RequestStatus<bool>? deleteStatus,
  }) {
    return TableDetailFree(
      table: table ?? this.table,
      startStatus: startStatus ?? this.startStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [table, startStatus, deleteStatus];
}

@immutable
final class TableDetailOccupied extends TableDetailState {
  const TableDetailOccupied({
    required this.table,
    required this.session,
    this.deleteStatus = const RequestInitial(),
  });

  final TableModel table;
  final SessionModel session;
  final RequestStatus<bool> deleteStatus;

  TableDetailOccupied copyWith({
    TableModel? table,
    SessionModel? session,
    RequestStatus<bool>? deleteStatus,
  }) {
    return TableDetailOccupied(
      table: table ?? this.table,
      session: session ?? this.session,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [table, session, deleteStatus];
}
