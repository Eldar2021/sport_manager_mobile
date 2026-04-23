import 'dart:async';

import 'package:api_client/api_client.dart';

Type _getType<T>() => T;
final Type _voidType = _getType<void>();

typedef FromJson<T> = T Function(Map<String, dynamic>);
typedef ResolveValue = String? Function();

class ApiClient with ConverterMixin {
  const ApiClient._(this.requestExecutor);

  factory ApiClient.fromDio({
    required Dio dio,
    required ConnectionService connection,
  }) {
    return ApiClient._(DioRequestExecutor(dio, connection));
  }

  static const bearerInstance = 'bearerInstance';
  static const noneAuthInstance = 'noneAuthInstance';

  final RequestExecutor requestExecutor;

  Future<Response<T>> getResponse<T>(
    String path, {
    Object? data,
    GetApiParams? params,
  }) {
    return requestExecutor.request<T>(
      path,
      method: RequestType.get,
      data: data,
      queryParameters: params?.queryParameters,
      cancelToken: params?.cancelToken,
      options: params?.options,
      onReceiveProgress: params?.onReceiveProgress,
    );
  }

  Future<T> get<T>(
    String path, {
    Object? data,
    GetApiParams? params,
  }) async {
    final response = await getResponse<T>(
      path,
      data: data,
      params: params,
    );
    if (T == _voidType) return response as T;
    return response.data as T;
  }

  Future<T> getType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    GetApiParams? params,
  }) {
    return get<Map<String, dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertType<T>(v, fromJson));
  }

  Future<List<T>> getListOfType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    GetApiParams? params,
  }) {
    return get<List<dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertListOfType<T>(v, fromJson));
  }

  Future<Response<T>> postResponse<T>(
    String path, {
    Object? data,
    PostApiParams? params,
  }) {
    return requestExecutor.request<T>(
      path,
      method: RequestType.post,
      data: data,
      queryParameters: params?.queryParameters,
      options: params?.options,
      cancelToken: params?.cancelToken,
      onSendProgress: params?.onSendProgress,
      onReceiveProgress: params?.onReceiveProgress,
    );
  }

  Future<T> post<T>(
    String path, {
    Object? data,
    PostApiParams? params,
  }) async {
    final response = await postResponse<T>(
      path,
      data: data,
      params: params,
    );
    if (T == _voidType) return response as T;
    return response.data as T;
  }

  Future<T> postType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    PostApiParams? params,
  }) {
    return post<Map<String, dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertType<T>(v, fromJson));
  }

  Future<List<T>> postListOfType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    PostApiParams? params,
  }) {
    return post<List<dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertListOfType<T>(v, fromJson));
  }

  Future<Response<T>> putResponse<T>(
    String path, {
    Object? data,
    PutApiParams? params,
  }) {
    return requestExecutor.request<T>(
      path,
      method: RequestType.put,
      data: data,
      queryParameters: params?.queryParameters,
      options: params?.options,
      cancelToken: params?.cancelToken,
      onSendProgress: params?.onSendProgress,
      onReceiveProgress: params?.onReceiveProgress,
    );
  }

  Future<T> put<T>(
    String path, {
    Object? data,
    PutApiParams? params,
  }) async {
    final response = await putResponse<T>(
      path,
      data: data,
      params: params,
    );
    if (T == _voidType) return response as T;
    return response.data as T;
  }

  Future<T> putType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    PutApiParams? params,
  }) {
    return put<Map<String, dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertType<T>(v, fromJson));
  }

  Future<List<T>> putListOfType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    PutApiParams? params,
  }) {
    return put<List<dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertListOfType<T>(v, fromJson));
  }

  Future<Response<T>> patchResponse<T>(
    String path, {
    Object? data,
    PatchApiParams? params,
  }) {
    return requestExecutor.request<T>(
      path,
      method: RequestType.patch,
      data: data,
      queryParameters: params?.queryParameters,
      options: params?.options,
      cancelToken: params?.cancelToken,
      onSendProgress: params?.onSendProgress,
      onReceiveProgress: params?.onReceiveProgress,
    );
  }

  Future<T> patch<T>(
    String path, {
    Object? data,
    PatchApiParams? params,
  }) async {
    final response = await patchResponse<T>(
      path,
      data: data,
      params: params,
    );
    if (T == _voidType) return response as T;
    return response.data as T;
  }

  Future<T> patchType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    PatchApiParams? params,
  }) {
    return patch<Map<String, dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertType<T>(v, fromJson));
  }

  Future<List<T>> patchListOfType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    PatchApiParams? params,
  }) {
    return patch<List<dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertListOfType<T>(v, fromJson));
  }

  Future<Response<T>> deleteResponse<T>(
    String path, {
    Object? data,
    DeleteApiParams? params,
  }) {
    return requestExecutor.request<T>(
      path,
      method: RequestType.delete,
      data: data,
      queryParameters: params?.queryParameters,
      options: params?.options,
      cancelToken: params?.cancelToken,
    );
  }

  Future<T> delete<T>(
    String path, {
    Object? data,
    DeleteApiParams? params,
  }) async {
    final response = await deleteResponse<T>(
      path,
      data: data,
      params: params,
    );
    if (T == _voidType) return response as T;
    return response.data as T;
  }

  Future<T> deleteType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    DeleteApiParams? params,
  }) {
    return delete<Map<String, dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertType<T>(v, fromJson));
  }

  Future<List<T>> deleteListOfType<T>(
    String path, {
    required FromJson<T> fromJson,
    Object? data,
    DeleteApiParams? params,
  }) {
    return delete<List<dynamic>>(
      path,
      data: data,
      params: params,
    ).then((v) => convertListOfType<T>(v, fromJson));
  }
}
