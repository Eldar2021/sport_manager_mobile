import 'package:api_client/api_client.dart';
import 'package:facility/facility.dart';
import 'package:meta/meta.dart';

@immutable
final class SessionRemoteSourceImpl implements SessionRemoteSource {
  const SessionRemoteSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<SessionModel> startSession(
    String tableId,
    String? customerName,
  ) {
    return _client
        .postType<SessionModel>(
          '/api/v1/session/start',
          fromJson: SessionModel.fromJson,
          data: {
            'tableId': tableId,
            'customerName': ?customerName,
          },
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SessionModel> pauseSession(String sessionId) {
    return _client
        .postType<SessionModel>(
          '/api/v1/session/$sessionId/pause',
          fromJson: SessionModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SessionModel> resumeSession(String sessionId) {
    return _client
        .postType<SessionModel>(
          '/api/v1/session/$sessionId/resume',
          fromJson: SessionModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SessionModel> finishSession(
    String sessionId,
    int? discountPercent,
  ) {
    return _client
        .postType<SessionModel>(
          '/api/v1/session/$sessionId/finish',
          fromJson: SessionModel.fromJson,
          data: {'discountPercent': discountPercent},
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SessionModel> cancelSession(
    String sessionId,
    String? cancelReason,
  ) {
    return _client
        .postType<SessionModel>(
          '/api/v1/session/$sessionId/cancel',
          fromJson: SessionModel.fromJson,
          data: {'reason': cancelReason ?? 'Canceled by user'},
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SessionModel> addProductToSession(
    String sessionId,
    String productId,
  ) {
    return _client
        .postType<SessionModel>(
          '/api/v1/session/$sessionId/items',
          fromJson: SessionModel.fromJson,
          data: {'productId': productId},
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SessionModel> removeProductFromSession(
    String sessionId,
    String itemId,
  ) {
    return _client
        .deleteType<SessionModel>(
          '/api/v1/session/$sessionId/items/$itemId',
          fromJson: SessionModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }
}
