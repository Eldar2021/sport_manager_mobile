import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

typedef RefreshTokenCallback = Future<String?> Function();

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.dio,
    required this.getRefreshToken,
    required this.onLogout,
    required this.onRefreshedToken,
  });

  final Dio dio;
  final String Function() getRefreshToken;
  final Future<void> Function() onLogout;
  final void Function(String, String) onRefreshedToken;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.path.contains('auth/login')) {
        await onLogout();
        return handler.next(err);
      }
      if (err.requestOptions.path.contains('auth/refresh')) {
        return handler.next(err);
      }
      try {
        final newToken = await refresh();
        if (newToken != null && newToken.isNotEmpty) {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          final response = await dio.request<dynamic>(
            options.path,
            data: options.data,
            queryParameters: options.queryParameters,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
          );

          if (response.statusCode == 401) {
            return handler.next(err);
          }

          return handler.resolve(response);
        } else {
          return handler.next(err);
        }
      } on Object catch (_) {
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  Future<String?> refresh() async {
    try {
      final res = await dio.post<Map<String, dynamic>>(
        'auth/refresh',
        data: {
          'refreshToken': getRefreshToken(),
        },
      );
      if (res.statusCode == 200 && res.data != null && res.data is Map<String, dynamic>) {
        final accessToken = res.data?['accessToken'] as String;
        final refreshToken = res.data?['refreshToken'] as String;
        onRefreshedToken(accessToken, refreshToken);
        return accessToken;
      } else {
        await onLogout();
        throw ApiClientException(
          DioException(
            requestOptions: RequestOptions(path: 'auth/refresh'),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 401,
              data: BaseMessage.sessionExpired,
            ),
          ),
        );
      }
    } on Object catch (_) {
      await onLogout();
      throw ApiClientException(
        DioException(
          requestOptions: RequestOptions(path: 'auth/refresh'),
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 401,
            data: BaseMessage.sessionExpired,
          ),
        ),
      );
    }
  }
}
