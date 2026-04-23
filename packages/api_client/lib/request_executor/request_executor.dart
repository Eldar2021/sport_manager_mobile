import 'package:api_client/api_client.dart';

abstract interface class RequestExecutor {
  Future<Response<T>> request<T>(
    String path, {
    required RequestType method,
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });
}
