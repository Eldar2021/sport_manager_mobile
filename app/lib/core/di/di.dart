import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';

export 'base/base_di_module.dart';
export 'modules/core_module.dart';
export 'modules/error_module.dart';
export 'modules/network_module.dart';

Future<void> diInit(
  GetIt instance,
  List<BaseDiModule> modules,
) async {
  for (final module in modules) {
    await module.register(instance);
  }
}
