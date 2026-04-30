import 'dart:async';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'session_active_state.dart';

class SessionActiveCubit extends Cubit<SessionActiveState> {
  SessionActiveCubit({
    required SessionModel session,
    required SessionRepository repository,
  }) : _repo = repository,
       super(SessionActiveState(session: session)) {
    _startTimer();
  }

  final SessionRepository _repo;
  StreamSubscription<void>? _timerSub;

  void _startTimer() {
    _timerSub?.cancel();
    _tick();
    _timerSub = Stream<void>.periodic(const Duration(seconds: 1)).listen(
      (_) => _tick(),
    );
  }

  void _stopTimer() {
    _timerSub?.cancel();
    _timerSub = null;
  }

  void _tick() {
    final session = state.session;
    final raw = DateTime.now().difference(session.startedAt) - Duration(seconds: session.totalPausedSeconds);
    emit(state.copyWith(elapsed: raw.isNegative ? Duration.zero : raw));
  }

  Future<void> confirmStop() async {
    _stopTimer();
    emit(state.copyWith(stopStatus: const RequestLoading()));
    try {
      final discount = state.effectiveDiscount > 0 ? state.effectiveDiscount : null;
      final result = await _repo.finishSession(
        state.session.id,
        discount,
      );
      emit(state.copyWith(stopStatus: RequestSuccess(result)));
    } on Object catch (e) {
      _startTimer();
      emit(state.copyWith(stopStatus: RequestFailure(e)));
    }
  }

  Future<void> cancelSession() async {
    _stopTimer();
    emit(state.copyWith(cancelStatus: const RequestLoading()));
    try {
      final result = await _repo.cancelSession(
        state.session.id,
        null,
      );
      emit(
        state.copyWith(cancelStatus: RequestSuccess(result)),
      );
    } on Object catch (e) {
      _startTimer();
      emit(state.copyWith(cancelStatus: RequestFailure(e)));
    }
  }

  void selectDiscount(int value) {
    emit(
      state.copyWith(
        selectedDiscount: value,
        customDiscount: null,
      ),
    );
  }

  void setCustomDiscount(int value) {
    emit(state.copyWith(customDiscount: value));
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
