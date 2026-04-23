import 'package:api_client/api_client.dart';
import 'package:meta/meta.dart';

@immutable
sealed class ApiParams {
  const ApiParams({
    this.queryParameters,
    this.options,
    this.cancelToken,
  });

  final Map<String, dynamic>? queryParameters;
  final Options? options;
  final CancelToken? cancelToken;
}

@immutable
final class GetApiParams extends ApiParams {
  const GetApiParams({
    super.queryParameters,
    super.options,
    super.cancelToken,
    this.onReceiveProgress,
  });

  final ProgressCallback? onReceiveProgress;
}

@immutable
final class PostApiParams extends ApiParams {
  const PostApiParams({
    super.queryParameters,
    super.options,
    super.cancelToken,
    this.onSendProgress,
    this.onReceiveProgress,
  });

  final ProgressCallback? onSendProgress;
  final ProgressCallback? onReceiveProgress;
}

@immutable
final class PutApiParams extends PostApiParams {
  const PutApiParams({
    super.queryParameters,
    super.options,
    super.cancelToken,
    super.onSendProgress,
    super.onReceiveProgress,
  });
}

@immutable
final class PatchApiParams extends PostApiParams {
  const PatchApiParams({
    super.queryParameters,
    super.options,
    super.cancelToken,
    super.onSendProgress,
    super.onReceiveProgress,
  });
}

@immutable
final class DeleteApiParams extends ApiParams {
  const DeleteApiParams({
    super.queryParameters,
    super.options,
    super.cancelToken,
  });
}
