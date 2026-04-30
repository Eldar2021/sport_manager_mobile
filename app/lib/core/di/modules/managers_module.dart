import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:managers/managers.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';

final class ManagersModule extends BaseDiModule {
  const ManagersModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);

    sl
      ..registerLazySingleton<ManagerRemoteSource>(
        () => Env.isMock
            ? ManagerRemoteSourceMock()
            : ManagerRemoteSourceImpl(
                sl<ApiClient>(instanceName: ApiClient.bearerInstance),
              ),
      )
      ..registerLazySingleton<ManagerRepository>(
        () => ManagerRepository(sl<ManagerRemoteSource>()),
      );
  }
}
