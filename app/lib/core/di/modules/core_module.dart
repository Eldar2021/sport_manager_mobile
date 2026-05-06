import 'dart:async';

import 'package:core/core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:storage_client/storage_client.dart';

final class CoreModule extends BaseDiModule {
  const CoreModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);
    final storage = await PreferencesStorage.getInstance();

    final firebaseRemoteConfigClient = FirebaseRemoteConfigClientImpl(
      FirebaseRemoteConfig.instance,
    );

    final remoteConfigRepository = RemoteConfigRepositoryImpl(
      firebaseRemoteConfigClient,
    );

    await remoteConfigRepository.init(AppConfigEntries.all);

    sl
      ..registerLazySingleton<PreferencesStorage>(() => storage)
      ..registerLazySingleton<RemoteConfigRepository>(() => remoteConfigRepository);
  }
}
