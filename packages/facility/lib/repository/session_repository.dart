import 'package:facility/models/session_model.dart';
import 'package:facility/source/remote/session_remote_source.dart';
import 'package:meta/meta.dart';

@immutable
final class SessionRepository {
  const SessionRepository(this._remote);

  final SessionRemoteSource _remote;

  Future<SessionModel> startSession(String spotId, String? customerName) {
    return _remote.startSession(spotId, customerName);
  }

  Future<SessionModel> pauseSession(String sessionId) {
    return _remote.pauseSession(sessionId);
  }

  Future<SessionModel> resumeSession(String sessionId) {
    return _remote.resumeSession(sessionId);
  }

  Future<SessionModel> finishSession(
    String sessionId,
    int? discountPercent,
  ) {
    return _remote.finishSession(sessionId, discountPercent);
  }

  Future<SessionModel> cancelSession(
    String sessionId,
    String? cancelReason,
  ) {
    return _remote.cancelSession(sessionId, cancelReason);
  }
}
