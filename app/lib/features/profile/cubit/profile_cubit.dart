import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/state/data_state.dart';

class ProfileCubit extends Cubit<DataState<ProfileModel>> {
  ProfileCubit(this._authRepository) : super(const DataInitial<ProfileModel>());

  final AuthRepository _authRepository;

  Future<void> fetchProfile() async {
    emit(const DataLoading<ProfileModel>());
    try {
      final profile = await _authRepository.getProfile();
      emit(DataSuccess(profile));
    } on Object catch (e) {
      log('Error fetching profile: $e');
      emit(DataFailure<ProfileModel>(e));
    }
  }

  void clearState() {
    emit(const DataInitial<ProfileModel>());
  }
}
