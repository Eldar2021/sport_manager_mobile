import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';

final class RegisterManagerCubit extends Cubit<DataState<void>> {
  RegisterManagerCubit(this._repository, this._authCubit) : super(const DataInitial());

  final AuthRepository _repository;
  final AuthCubit _authCubit;

  Future<void> registerManager(RegisterManagerBody body) async {
    if (state.isLoading) return;
    emit(const DataLoading());
    try {
      final result = await _repository.registerManager(body);
      _authCubit.setAuthenticated(result.user);
      emit(const DataSuccess(null));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
