import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

final class RegisterCubit extends Cubit<DataState<AuthResultModel>> {
  RegisterCubit(this._repository) : super(const DataInitial());

  final AuthRepository _repository;

  Future<void> registerOwner(RegisterOwnerBody body) async {
    if (state.isLoading) return;
    emit(const DataLoading());
    try {
      final response = await _repository.registerOwner(body);
      emit(DataSuccess(response));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }

  Future<void> registerManager(RegisterManagerBody body) async {
    if (state.isLoading) return;
    emit(const DataLoading());
    try {
      final response = await _repository.registerManager(body);
      emit(DataSuccess(response));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
