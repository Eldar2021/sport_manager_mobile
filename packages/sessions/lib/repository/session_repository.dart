import 'package:meta/meta.dart';
import 'package:sessions/sessions.dart';

@immutable
final class SessionRepository {
  const SessionRepository({
    required SessionRemoteSource remote,
  }) : _remote = remote;

  final SessionRemoteSource _remote;

  Future<SessionModel> startSession(String tableId) {
    return _remote.startSession(tableId);
  }

  Future<void> cancelSession(String id) {
    return _remote.cancelSession(id);
  }

  Future<SessionModel> endSession(
    String id,
    EndSessionBody body,
  ) {
    return _remote.endSession(id, body);
  }

  Future<List<SessionModel>> getActiveSessions() {
    return _remote.getActiveSessions();
  }

  Future<SessionsResponse> getSessions(SessionsQuery query) {
    return _remote.getSessions(query);
  }
}
