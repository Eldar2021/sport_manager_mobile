part of 'table_detail_cubit.dart';

sealed class TableDetailState extends Equatable {
  const TableDetailState();
}

@immutable
final class TableDetailFree extends TableDetailState {
  const TableDetailFree({
    required this.table,
    this.startStatus = const RequestInitial(),
  });

  final TableModel table;
  final RequestStatus<SessionModel> startStatus;

  TableDetailFree copyWith({
    RequestStatus<SessionModel>? startStatus,
    TableModel? table,
  }) {
    return TableDetailFree(
      table: table ?? this.table,
      startStatus: startStatus ?? this.startStatus,
    );
  }

  @override
  List<Object?> get props => [
    table,
    startStatus,
  ];
}

final class TableDetailOccupied extends TableDetailState {
  const TableDetailOccupied({
    required this.table,
    required this.sessionCubit,
  });

  final TableModel table;
  final SessionActiveCubit sessionCubit;

  @override
  List<Object?> get props => [
    table,
    sessionCubit,
  ];
}
