import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tables/tables.dart';

part 'create_table_state.dart';

class CreateTableCubit extends Cubit<CreateTableState> {
  CreateTableCubit(
    this._repository,
    this._venueId, {
    TableModel? initialTable,
  }) : _tableId = initialTable?.id,
       super(
         initialTable != null
             ? CreateTableState(
                 name: initialTable.name ?? '',
                 description: initialTable.description ?? '',
                 hourlyRate: initialTable.hourlyRate,
               )
             : const CreateTableState(),
       );

  final TableRepository _repository;
  final String _venueId;
  final String? _tableId;

  bool get isEditMode => _tableId != null;

  void updateName(String value) {
    emit(state.copyWith(name: value));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value));
  }

  void updateRate(int value) {
    emit(state.copyWith(hourlyRate: value));
  }

  Future<void> submit() async {
    if (!state.isValid) return;
    emit(state.copyWith(submitStatus: const RequestLoading()));
    try {
      final TableModel result;
      if (_tableId != null) {
        result = await _repository.updateTable(
          _tableId,
          UpdateTableBody(
            name: state.name.trim(),
            number: state.name.trim(),
            hourlyRate: state.hourlyRate,
          ),
        );
      } else {
        result = await _repository.createTable(
          _venueId,
          CreateTableBody(
            number: state.name.trim(),
            name: state.name.trim(),
            hourlyRate: state.hourlyRate,
          ),
        );
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
