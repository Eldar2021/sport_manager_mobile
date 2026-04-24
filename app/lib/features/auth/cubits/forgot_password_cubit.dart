import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

final class ForgotPasswordCubit extends Cubit<DataState<void>> {
  ForgotPasswordCubit(this._repository) : super(const DataInitial());

  final AuthRepository _repository;

  Future<void> send(String email) async {
    if (state.isLoading) return;
    emit(const DataLoading());
    try {
      await _repository.forgotPassword(email);
      emit(const DataSuccess(null));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
