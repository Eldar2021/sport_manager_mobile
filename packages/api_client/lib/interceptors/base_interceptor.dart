import 'package:api_client/api_client.dart';

class BaseInterceptor extends Interceptor {
  const BaseInterceptor({
    this.language,
    this.buildNumber,
    this.platform,
  });

  final ResolveValue? language;
  final ResolveValue? buildNumber;
  final ResolveValue? platform;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final languageValue = language?.call();
    final buildNumberValue = buildNumber?.call();
    final platformValue = platform?.call();
    options.headers.addAll({
      if (languageValue != null && languageValue.isNotEmpty) 'Accept-Language': languageValue,
      if (buildNumberValue != null && buildNumberValue.isNotEmpty) 'versionBuild': buildNumberValue,
      if (platformValue != null && platformValue.isNotEmpty) 'os': platformValue,
    });
    return handler.next(options);
  }
}
