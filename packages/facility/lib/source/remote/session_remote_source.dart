import 'package:facility/facility.dart';

abstract interface class SessionRemoteSource {
  Future<SessionModel> startSession(
    String tableId,
    String? customerName,
  );

  Future<SessionModel> pauseSession(String sessionId);

  Future<SessionModel> resumeSession(String sessionId);

  Future<SessionModel> finishSession(
    String sessionId,
    int? discountPercent,
  );

  Future<SessionModel> cancelSession(
    String sessionId,
    String? cancelReason,
  );

  Future<SessionModel> addProductToSession(
    String sessionId,
    String productId,
  );

  Future<SessionModel> removeProductFromSession(
    String sessionId,
    String itemId,
  );
}
