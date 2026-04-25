import 'package:sessions/sessions.dart';

abstract interface class SessionRemoteSource {
  Future<SessionModel> startSession(String tableId);

  Future<void> cancelSession(String id);

  Future<SessionModel> endSession(String id, EndSessionBody body);

  Future<List<SessionModel>> getActiveSessions();

  Future<SessionsResponse> getSessions(SessionsQuery query);
}
