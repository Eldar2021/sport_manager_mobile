import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:storage_client/storage_client.dart';

final class CoreModule extends BaseDiModule {
  const CoreModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);
    final storage = await PreferencesStorage.getInstance();

    sl.registerLazySingleton<PreferencesStorage>(() => storage);
  }
}
