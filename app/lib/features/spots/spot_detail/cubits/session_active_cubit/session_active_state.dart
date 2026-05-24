part of 'session_active_cubit.dart';

final class _Absent {
  const _Absent();
}

const _absent = _Absent();

@immutable
final class SessionActiveState extends Equatable {
  const SessionActiveState({
    required this.session,
    this.stopStatus = const RequestInitial(),
    this.cancelStatus = const RequestInitial(),
    this.elapsed = Duration.zero,
    this.selectedDiscount = 0,
    this.customDiscount,
    this.pauseStatus = const RequestInitial(),
    this.resumeStatus = const RequestInitial(),
    this.addProductStatus = const RequestInitial(),
    this.removeProductStatus = const RequestInitial(),
  });

  final SessionModel session;
  final RequestStatus<SessionModel> stopStatus;
  final RequestStatus<SessionModel> cancelStatus;
  final RequestStatus<SessionModel> pauseStatus;
  final RequestStatus<SessionModel> resumeStatus;
  final RequestStatus<SessionModel> addProductStatus;
  final RequestStatus<void> removeProductStatus;
  final Duration elapsed;
  final int selectedDiscount;
  final int? customDiscount;

  int get effectiveDiscount => customDiscount ?? selectedDiscount;

  int get timeAmount {
    final tarif = session.tarifAmountSnapshot ?? 0;
    final divisor = switch (session.tarifTypeSnapshot) {
      TarifType.hour => 3600.0,
      TarifType.minute => 60.0,
      TarifType.day => 86400.0,
      null => 3600.0,
    };
    return (elapsed.inSeconds.clamp(0, double.maxFinite.toInt()) / divisor * tarif).round();
  }

  int get currentAmount => timeAmount + session.productsAmount;

  SessionActiveState copyWith({
    SessionModel? session,
    RequestStatus<SessionModel>? stopStatus,
    RequestStatus<SessionModel>? cancelStatus,
    RequestStatus<SessionModel>? pauseStatus,
    RequestStatus<SessionModel>? resumeStatus,
    RequestStatus<SessionModel>? addProductStatus,
    RequestStatus<void>? removeProductStatus,
    Duration? elapsed,
    int? selectedDiscount,
    Object? customDiscount = _absent,
  }) {
    return SessionActiveState(
      session: session ?? this.session,
      stopStatus: stopStatus ?? this.stopStatus,
      cancelStatus: cancelStatus ?? this.cancelStatus,
      pauseStatus: pauseStatus ?? this.pauseStatus,
      resumeStatus: resumeStatus ?? this.resumeStatus,
      addProductStatus: addProductStatus ?? this.addProductStatus,
      removeProductStatus: removeProductStatus ?? this.removeProductStatus,
      elapsed: elapsed ?? this.elapsed,
      selectedDiscount: selectedDiscount ?? this.selectedDiscount,
      customDiscount: customDiscount is _Absent ? this.customDiscount : customDiscount as int?,
    );
  }

  @override
  List<Object?> get props => [
    session,
    stopStatus,
    cancelStatus,
    pauseStatus,
    resumeStatus,
    addProductStatus,
    removeProductStatus,
    elapsed,
    selectedDiscount,
    customDiscount,
  ];
}
