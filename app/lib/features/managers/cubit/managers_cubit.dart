import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managers/managers.dart';
import 'package:meta/meta.dart';

part 'managers_state.dart';

class ManagersCubit extends Cubit<ManagersState> {
  ManagersCubit({
    required AuthRepository authRepository,
    required ManagerRepository managerRepository,
  }) : _authRepository = authRepository,
       _managerRepository = managerRepository,
       super(const ManagersState());

  final AuthRepository _authRepository;
  final ManagerRepository _managerRepository;

  Future<void> load() async {
    await Future.wait([
      loadInviteCode(),
      loadManagers(),
    ]);
  }

  Future<void> loadInviteCode() async {
    emit(state.copyWith(inviteCode: const RequestLoading()));
    try {
      final code = await _authRepository.getInviteCode();
      emit(state.copyWith(inviteCode: RequestSuccess(code)));
    } on Object catch (e) {
      emit(state.copyWith(inviteCode: RequestFailure(e)));
    }
  }

  Future<void> loadManagers() async {
    emit(state.copyWith(managers: const RequestLoading()));
    try {
      final managers = await _managerRepository.getManagers();
      emit(state.copyWith(managers: RequestSuccess(managers)));
    } on Object catch (e) {
      emit(state.copyWith(managers: RequestFailure(e)));
    }
  }

  Future<void> deleteManager(String id) async {
    if (state.deletingId != null) return;
    emit(state.copyWith(deletingId: id));
    try {
      await _managerRepository.deleteManager(id);
      final current = state.managers.dataOrNull ?? const [];
      final next = current.where((m) => m.id != id).toList(growable: false);
      emit(
        state.copyWith(
          managers: RequestSuccess(next),
          clearDeletingId: true,
        ),
      );
    } on Object catch (_) {
      emit(state.copyWith(clearDeletingId: true));
      rethrow;
    }
  }
}
