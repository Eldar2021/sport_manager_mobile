import 'package:facility/facility.dart';

final class SessionRemoteSourceMock implements SessionRemoteSource {
  Map<String, SessionModel> get _sessions => MockData.sessions;

  @override
  Future<SessionModel> startSession(String spotId, String? customerName) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final hasActive = _sessions.values.any(
      (s) => s.spotId == spotId && (s.isActive || s.isPaused),
    );
    if (hasActive) throw const FacilityExc(FacilityErrorCode.spotHasActiveSession);

    final session = SessionModel(
      id: 'session-${DateTime.now().millisecondsSinceEpoch}',
      spotId: spotId,
      status: SessionStatus.active,
      startedAt: DateTime.now(),
      tarifAmountSnapshot: 500,
      tarifTypeSnapshot: TarifType.hour,
    );
    _sessions[session.id] = session;
    MockData.updateSpotSession(spotId, session);
    return session;
  }

  @override
  Future<SessionModel> pauseSession(String sessionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final session = _sessions[sessionId];
    if (session == null) throw const FacilityExc(FacilityErrorCode.sessionNotFound);
    if (!session.isActive) throw const FacilityExc(FacilityErrorCode.sessionNotActive);

    final paused = SessionModel(
      id: session.id,
      spotId: session.spotId,
      status: SessionStatus.paused,
      startedAt: session.startedAt,
      totalPausedSeconds: session.totalPausedSeconds,
      pausedAt: DateTime.now(),
      tarifAmountSnapshot: session.tarifAmountSnapshot,
      tarifTypeSnapshot: session.tarifTypeSnapshot,
    );
    _sessions[sessionId] = paused;
    MockData.updateSpotSession(session.spotId, paused);
    return paused;
  }

  @override
  Future<SessionModel> resumeSession(String sessionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final session = _sessions[sessionId];
    if (session == null) throw const FacilityExc(FacilityErrorCode.sessionNotFound);
    if (!session.isPaused) throw const FacilityExc(FacilityErrorCode.sessionNotPaused);

    final extra = session.pausedAt != null ? DateTime.now().difference(session.pausedAt!).inSeconds : 0;
    final resumed = SessionModel(
      id: session.id,
      spotId: session.spotId,
      status: SessionStatus.active,
      startedAt: session.startedAt,
      totalPausedSeconds: session.totalPausedSeconds + extra,
      tarifAmountSnapshot: session.tarifAmountSnapshot,
      tarifTypeSnapshot: session.tarifTypeSnapshot,
    );
    _sessions[sessionId] = resumed;
    MockData.updateSpotSession(session.spotId, resumed);
    return resumed;
  }

  @override
  Future<SessionModel> finishSession(
    String sessionId,
    int? discountPercent,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final discount = discountPercent ?? 0;
    if (discount < 0 || discount > 100) throw const FacilityExc(FacilityErrorCode.invalidDiscount);

    var session = _sessions[sessionId];
    if (session == null) throw const FacilityExc(FacilityErrorCode.sessionNotFound);
    if (session.isCompleted || session.isCancelled) {
      throw const FacilityExc(FacilityErrorCode.sessionAlreadyCompleted);
    }

    if (session.isPaused && session.pausedAt != null) {
      final extra = DateTime.now().difference(session.pausedAt!).inSeconds;
      session = SessionModel(
        id: session.id,
        spotId: session.spotId,
        status: SessionStatus.active,
        startedAt: session.startedAt,
        totalPausedSeconds: session.totalPausedSeconds + extra,
        tarifAmountSnapshot: session.tarifAmountSnapshot,
        tarifTypeSnapshot: session.tarifTypeSnapshot,
      );
    }

    final endedAt = DateTime.now();
    final billableSeconds = endedAt.difference(session.startedAt).inSeconds - session.totalPausedSeconds;
    final unitDivisor = switch (session.tarifTypeSnapshot) {
      TarifType.hour => 3600,
      TarifType.minute => 60,
      TarifType.day => 86400,
      null => 3600,
    };
    final subtotal = (billableSeconds / unitDivisor * (session.tarifAmountSnapshot ?? 0)).round();
    final totalAmount = subtotal - (subtotal * discount / 100).round();

    _sessions.remove(sessionId);

    return SessionModel(
      id: session.id,
      spotId: session.spotId,
      status: SessionStatus.completed,
      startedAt: session.startedAt,
      endedAt: endedAt,
      durationSeconds: billableSeconds,
      subtotal: subtotal,
      discountPercent: discount,
      totalAmount: totalAmount,
    );
  }

  @override
  Future<SessionModel> cancelSession(
    String sessionId,
    String? cancelReason,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final session = _sessions[sessionId];
    if (session == null) throw const FacilityExc(FacilityErrorCode.sessionNotFound);
    if (session.isCompleted || session.isCancelled) {
      throw const FacilityExc(FacilityErrorCode.sessionAlreadyCompleted);
    }

    _sessions.remove(sessionId);

    return SessionModel(
      id: session.id,
      spotId: session.spotId,
      status: SessionStatus.cancelled,
      startedAt: session.startedAt,
      endedAt: DateTime.now(),
      cancelReason: cancelReason,
    );
  }
}
