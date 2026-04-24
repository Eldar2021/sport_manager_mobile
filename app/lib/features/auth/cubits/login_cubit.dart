import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

final class LoginCubit extends Cubit<DataState<AuthResultModel>> {
  LoginCubit(this._repository) : super(const DataInitial());

  final AuthRepository _repository;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (state.isLoading) return;
    emit(const DataLoading());
    try {
      final result = await _repository.login(
        username: username,
        password: password,
      );
      await _repository.saveToken(result.token);
      emit(DataSuccess(result));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }

  Future<void> logout() async {
    await _repository.clearToken();
  }
}
