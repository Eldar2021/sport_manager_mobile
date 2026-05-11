import 'package:api_client/api_client.dart';

class DioRequestExecutor implements RequestExecutor {
  const DioRequestExecutor(this.dio, this.connection);

  final Dio dio;
  final ConnectionService connection;

  @override
  Future<Response<T>> request<T>(
    String path, {
    required RequestType method,
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (await connection.checkInternetConnection()) {
        final res = await dio.request<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken,
          options: (options ?? Options()).copyWith(method: method.value),
        );
        return res;
      } else {
        throw const ConnectionException('No internet connection');
      }
    } on DioException catch (e, s) {
      throw ApiClientException(
        e,
        stackTrace: s,
        code: _parseErrorCode(e),
      );
    } on ConnectionException {
      rethrow;
    } catch (e, s) {
      throw ApiClientUnknownException(e, stackTrace: s);
    }
  }

  String? _parseErrorCode(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return data['code'] as String?;
      }
      return null;
    } on Object catch (_) {
      return null;
    }
  }
}
