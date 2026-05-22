import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';

final class ProductModule extends BaseDiModule {
  const ProductModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);

    sl
      ..registerLazySingleton<ProductRemoteSource>(
        () => Env.isMock
            ? ProductRemoteSourceMock()
            : ProductRemoteSourceImpl(
                sl<ApiClient>(instanceName: ApiClient.bearerInstance),
              ),
      )
      ..registerLazySingleton<ProductRepository>(
        () => ProductRepository(sl<ProductRemoteSource>()),
      );
  }
}
