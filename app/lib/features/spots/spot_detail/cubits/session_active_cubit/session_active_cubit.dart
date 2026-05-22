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
    final now = session.isPaused ? (session.pausedAt ?? DateTime.now()) : DateTime.now();
    final raw = now.difference(session.startedAt) - Duration(seconds: session.totalPausedSeconds);
    emit(state.copyWith(elapsed: raw.isNegative ? Duration.zero : raw));
  }

  Future<void> pauseSession() async {
    if (state.pauseStatus is RequestLoading) return;
    await _request(
      () => _repo.pauseSession(state.session.id),
      (res) => state.copyWith(session: res, pauseStatus: RequestSuccess(res)),
      (e) => state.copyWith(pauseStatus: RequestFailure(e)),
      state.copyWith(pauseStatus: const RequestLoading()),
    );
  }

  Future<void> resumeSession() async {
    if (state.resumeStatus is RequestLoading) return;
    await _request(
      () => _repo.resumeSession(state.session.id),
      (res) => state.copyWith(session: res, resumeStatus: RequestSuccess(res)),
      (e) => state.copyWith(resumeStatus: RequestFailure(e)),
      state.copyWith(resumeStatus: const RequestLoading()),
    );
  }

  Future<void> _request<T>(
    Future<T> Function() action,
    SessionActiveState Function(T res) onSuccess,
    SessionActiveState Function(Object e) onFailure,
    SessionActiveState loading,
  ) async {
    emit(loading);
    try {
      final res = await action();
      emit(onSuccess(res));
    } on Object catch (e) {
      emit(onFailure(e));
    }
  }

  Future<void> confirmStop() async {
    if (state.stopStatus is RequestLoading) return;
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
    if (state.cancelStatus is RequestLoading) return;
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

  void updateSession(SessionModel session) {
    emit(state.copyWith(session: session));
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
