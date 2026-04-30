import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';
import 'package:subscription/subscription.dart';

final class SubscriptionModule extends BaseDiModule {
  const SubscriptionModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);

    sl
      ..registerLazySingleton<SubscriptionRemoteSource>(
        () => Env.isMock
            ? SubscriptionRemoteSourceMock()
            : SubscriptionRemoteSourceImpl(
                sl<ApiClient>(instanceName: ApiClient.bearerInstance),
              ),
      )
      ..registerLazySingleton<SubscriptionRepository>(
        () => SubscriptionRepository(sl<SubscriptionRemoteSource>()),
      );
  }
}
