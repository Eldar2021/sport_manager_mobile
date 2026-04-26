import 'package:api_client/api_client.dart';
import 'package:meta/meta.dart';
import 'package:sessions/sessions.dart';

@immutable
final class SessionRemoteSourceImpl implements SessionRemoteSource {
  const SessionRemoteSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<SessionModel> startSession(String tableId) {
    return _client.postType<SessionModel>(
      '/tables/$tableId/sessions/start',
      fromJson: SessionModel.fromJson,
    );
  }

  @override
  Future<void> cancelSession(String id) {
    return _client.post('/sessions/$id/cancel');
  }

  @override
  Future<SessionModel> endSession(
    String id,
    EndSessionBody body,
  ) {
    return _client.postType<SessionModel>(
      '/sessions/$id/end',
      fromJson: SessionModel.fromJson,
      data: body.toJson(),
    );
  }

  @override
  Future<List<SessionModel>> getActiveSessions() {
    return _client.getListOfType<SessionModel>(
      '/sessions/active',
      fromJson: SessionModel.fromJson,
    );
  }

  @override
  Future<SessionsResponse> getSessions(SessionsQuery query) {
    return _client.getType<SessionsResponse>(
      '/sessions',
      fromJson: SessionsResponse.fromJson,
      params: GetApiParams(queryParameters: query.toQueryParameters()),
    );
  }
}
