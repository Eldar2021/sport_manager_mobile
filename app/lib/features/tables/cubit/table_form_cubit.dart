import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'table_form_state.dart';

class TableFormCubit extends Cubit<TableFormState> {
  TableFormCubit(
    this._repository,
    this._venueId,
    this._tableId,
  ) : super(const TableFormState());

  final FacilityRepository _repository;
  final String _venueId;
  final String? _tableId;

  Future<void> submit(TableFormParam param) async {
    emit(state.copyWith(submitStatus: const RequestLoading()));
    try {
      final TableModel result;
      if (_tableId != null) {
        result = await _repository.updateTable(_tableId, param);
      } else {
        result = await _repository.createTable(_venueId, param);
      }
      emit(state.copyWith(submitStatus: RequestSuccess(result)));
    } on Object catch (e) {
      emit(state.copyWith(submitStatus: RequestFailure(e)));
    }
  }

  Future<void> deleteTable() async {
    if (_tableId == null) return;
    emit(state.copyWith(deleteStatus: const RequestLoading()));
    try {
      await _repository.deleteTable(_tableId);
      emit(state.copyWith(deleteStatus: const RequestSuccess(true)));
    } on Object catch (e) {
      emit(state.copyWith(deleteStatus: RequestFailure(e)));
    }
  }
}
