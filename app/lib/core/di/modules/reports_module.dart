import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';

final class ReportsModule extends BaseDiModule {
  const ReportsModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);

    sl
      ..registerLazySingleton<ReportsRemoteSource>(
        () => Env.isMock
            ? ReportsRemoteSourceMock()
            : ReportsRemoteSourceImpl(
                sl<ApiClient>(instanceName: ApiClient.bearerInstance),
              ),
      )
      ..registerLazySingleton<ReportsRepository>(
        () => ReportsRepository(sl<ReportsRemoteSource>()),
      );
  }
}
