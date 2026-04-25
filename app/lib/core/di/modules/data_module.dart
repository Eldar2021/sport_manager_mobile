import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:sessions/sessions.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';
import 'package:tables/tables.dart';
import 'package:venues/venues.dart';

final class DataModule extends BaseDiModule {
  const DataModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);

    sl
      // Shared authenticated API client
      ..registerLazySingleton<ApiClient>(
        () => ApiClient.fromDio(
          dio: sl<Dio>(instanceName: ApiClient.bearerInstance),
          connection: sl<ConnectionService>(),
        ),
        instanceName: ApiClient.bearerInstance,
      )
      // ── Venues ──────────────────────────────────────────────────────────
      ..registerLazySingleton<VenueRemoteSource>(
        () => Env.isMock
            ? VenueRemoteSourceMock()
            : VenueRemoteSourceImpl(sl<ApiClient>(instanceName: ApiClient.bearerInstance)),
      )
      ..registerLazySingleton<VenueRepository>(
        () => VenueRepository(remote: sl<VenueRemoteSource>()),
      )
      // ── Tables ──────────────────────────────────────────────────────────
      ..registerLazySingleton<TableRemoteSource>(
        () => Env.isMock
            ? TableRemoteSourceMock()
            : TableRemoteSourceImpl(sl<ApiClient>(instanceName: ApiClient.bearerInstance)),
      )
      ..registerLazySingleton<TableRepository>(
        () => TableRepository(remote: sl<TableRemoteSource>()),
      )
      // ── Sessions ─────────────────────────────────────────────────────────
      ..registerLazySingleton<SessionRemoteSource>(
        () => Env.isMock
            ? SessionRemoteSourceMock()
            : SessionRemoteSourceImpl(sl<ApiClient>(instanceName: ApiClient.bearerInstance)),
      )
      ..registerLazySingleton<SessionRepository>(
        () => SessionRepository(remote: sl<SessionRemoteSource>()),
      );
  }
}
