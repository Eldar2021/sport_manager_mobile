import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

class LoginCubit extends Cubit<DataState<AuthResultModel>> {
  LoginCubit(this._repository) : super(const DataInitial());

  final AuthRepository _repository;

  Future<void> login(String username, String password) async {
    emit(const DataLoading<AuthResultModel>());
    try {
      final result = await _repository.login(
        username: username.trim(),
        password: password,
      );
      emit(DataSuccess(result));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
