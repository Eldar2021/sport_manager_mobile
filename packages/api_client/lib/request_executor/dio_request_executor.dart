import 'dart:developer';
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
        log('ApiClient connection error $method $path');
        throw const ConnectionException('No internet connection');
      }
    } on DioException catch (e, s) {
      log('ApiClient request $method $path', error: e, stackTrace: s);
      final code = _parseErrorCode(e);
      throw ApiClientException(
        e,
        stackTrace: s,
        code: code,
      );
    } on ConnectionException {
      rethrow;
    } catch (e, s) {
      log('ApiClient request $method $path', error: e, stackTrace: s);
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
