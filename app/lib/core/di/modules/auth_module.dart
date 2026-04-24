import 'dart:async';
import 'package:auth/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:storage_client/storage_client.dart';

final class AuthModule extends BaseDiModule {
  const AuthModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);
    sl
      ..registerLazySingleton<AuthDataSource>(AuthMockDataSourceImpl.new)
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthDataSource>(), sl<PreferencesStorage>()),
      );
  }
}
