import 'dart:async';
import 'dart:io';
import 'package:api_client/api_client.dart';
import 'package:auth/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final class NetworkModule extends BaseDiModule {
  const NetworkModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);

    final baseOptions = BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    final baseInterceptor = BaseInterceptor(
      platform: () => Platform.isAndroid ? 'android' : 'ios',
    );

    final bearerDio = Dio(baseOptions);

    bearerDio.interceptors.addAll([
      baseInterceptor,
      BearerInterceptor(
        getAccessToken: () => GetIt.I<AuthLocalSource>().getAccessTokenSync() ?? '',
        getRefreshToken: () => GetIt.I<AuthLocalSource>().getRefreshTokenSync() ?? '',
      ),
      AuthInterceptor(
        dio: bearerDio,
        getRefreshToken: () => GetIt.I<AuthLocalSource>().getRefreshTokenSync() ?? '',
        onLogout: () => GetIt.I<AuthRepository>().logout(),
        onRefreshedToken: (accessToken, refreshToken) {
          GetIt.I<AuthLocalSource>().saveTokens(
            AuthTokensModel(accessToken: accessToken, refreshToken: refreshToken),
          );
        },
      ),
      if (Env.isDev) TalkerDioLogger(talker: talker),
    ]);

    final noneDio = Dio(baseOptions)..interceptors.add(baseInterceptor);
    if (Env.isDev) noneDio.interceptors.add(TalkerDioLogger(talker: talker));

    sl
      ..registerSingleton<Dio>(
        noneDio,
        instanceName: ApiClient.noneAuthInstance,
      )
      ..registerSingleton<Dio>(
        bearerDio,
        instanceName: ApiClient.bearerInstance,
      )
      ..registerSingleton<ConnectionService>(
        ConnectivityBasedConnectionChecker(),
      );
  }
}
