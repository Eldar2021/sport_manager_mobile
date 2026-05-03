import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sport_manager_mobile/core/core.dart';

part 'upgrader_state.dart';

class UpgraderCubit extends Cubit<UpgraderState> {
  UpgraderCubit(this._remoteConfig) : super(const UpgraderState());

  final RemoteConfigRepository _remoteConfig;
  StreamSubscription<void>? _configSub;
  String? _storeUrl;

  String get storeUrl => _storeUrl ?? '';

  Future<void> init() async {
    await check();
    _configSub = _remoteConfig.watch().listen((_) => check());
  }

  Future<void> check() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _storeUrl ??= StoreUrls.resolve(info);

      final build = int.tryParse(info.buildNumber) ?? 0;
      final config = _remoteConfig.get(AppConfigEntries.appVersion);
      final platform = Platform.isAndroid ? config.android : config.ios;

      final newStatus = switch (build) {
        _ when build < platform.requiredBuildNumber => UpgradeStatusEnum.required,
        _ when build < platform.recommendedBuildNumber => UpgradeStatusEnum.recommended,
        _ => UpgradeStatusEnum.none,
      };

      if (state.status == newStatus) return;
      emit(state.copyWith(status: newStatus));
    } on Object catch (e, s) {
      log('UpgraderCubit.check failed', error: e, stackTrace: s);
    }
  }

  void dismiss() {
    emit(const UpgraderState());
  }

  @override
  Future<void> close() {
    _configSub?.cancel();
    return super.close();
  }
}
