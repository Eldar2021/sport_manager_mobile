import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';

final class ManagerReportsModule extends BaseDiModule {
  const ManagerReportsModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);

    sl
      ..registerLazySingleton<ManagerReportsRemoteSource>(
        () => Env.isMock
            ? ManagerReportsRemoteSourceMock()
            : ManagerReportsRemoteSourceImpl(
                sl<ApiClient>(instanceName: ApiClient.bearerInstance),
              ),
      )
      ..registerLazySingleton<ManagerReportsRepository>(
        () => ManagerReportsRepository(sl<ManagerReportsRemoteSource>()),
      );
  }
}
