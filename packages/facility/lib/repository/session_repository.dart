import 'package:facility/facility.dart';
import 'package:meta/meta.dart';

@immutable
final class SessionRepository {
  const SessionRepository(this._remote);

  final SessionRemoteSource _remote;

  Future<SessionModel> startSession(
    String tableId,
    String? customerName,
  ) {
    return _remote.startSession(tableId, customerName);
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

  Future<SessionModel> addProductToSession(
    String sessionId,
    String productId,
  ) {
    return _remote.addProductToSession(sessionId, productId);
  }

  Future<SessionModel> removeProductFromSession(
    String sessionId,
    String itemId,
  ) {
    return _remote.removeProductFromSession(sessionId, itemId);
  }
}
