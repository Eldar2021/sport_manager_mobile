import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

extension MapApiErrors<T> on Future<T> {
  Future<T> mapTo<E extends Object>(
    AppException<E> Function(ApiClientException src) build,
  ) async {
    try {
      return await this;
    } on ApiClientException catch (e) {
      throw build(e);
    }
  }
}
