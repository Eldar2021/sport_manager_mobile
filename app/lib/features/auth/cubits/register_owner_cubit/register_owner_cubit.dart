import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';

final class RegisterOwnerCubit extends Cubit<DataState<void>> {
  RegisterOwnerCubit(this._repository, this._authCubit) : super(const DataInitial());

  final AuthRepository _repository;
  final AuthCubit _authCubit;

  Future<void> registerOwner(RegisterOwnerBody body) async {
    if (state.isLoading) return;
    emit(const DataLoading());
    try {
      final result = await _repository.registerOwner(body);
      _authCubit.setAuthenticated(result.user);
      emit(const DataSuccess(null));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
