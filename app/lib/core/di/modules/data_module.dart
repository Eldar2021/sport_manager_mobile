import 'dart:async';
import 'package:api_client/api_client.dart';
import 'package:facility/facility.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';

final class FacilityModule extends BaseDiModule {
  const FacilityModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);

    sl
      ..registerLazySingleton<ApiClient>(
        () => ApiClient.fromDio(
          dio: sl<Dio>(instanceName: ApiClient.bearerInstance),
          connection: sl<ConnectionService>(),
        ),
        instanceName: ApiClient.bearerInstance,
      )
      ..registerLazySingleton<FacilityRemoteSource>(
        () => Env.isMock
            ? FacilityRemoteSourceMock()
            : FacilityRemoteSourceImpl(
                sl<ApiClient>(instanceName: ApiClient.bearerInstance),
              ),
      )
      ..registerLazySingleton<FacilityRepository>(
        () => FacilityRepository(sl<FacilityRemoteSource>()),
      );
  }
}
