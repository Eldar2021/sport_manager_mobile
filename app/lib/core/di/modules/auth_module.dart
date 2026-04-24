import 'dart:async';

import 'package:api_client/clients/api_client.dart';
import 'package:auth/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';
import 'package:storage_client/storage_client.dart';

final class AuthModule extends BaseDiModule {
  const AuthModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);
    sl
      ..registerLazySingleton<AuthLocalSource>(
        () => Env.isMock ? AuthLocalSourceMock() : AuthLocalSourceImpl(sl<PreferencesStorage>()),
      )
      ..registerLazySingleton<AuthRemoteSource>(
        () => Env.isMock ? AuthRemoteSourceMock() : AuthRemoteSourceImpl(sl<ApiClient>()),
      )
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepository(
          local: sl<AuthLocalSource>(),
          remote: sl<AuthRemoteSource>(),
        ),
      );
  }
}
