import 'dart:developer';

import 'package:core/core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

final class FirebaseRemoteConfigClientImpl implements RemoteConfigClient {
  FirebaseRemoteConfigClientImpl(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  @override
  Future<void> init(Map<String, String> defaults) async {
    await _remoteConfig.setDefaults(defaults);
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );
    try {
      await _remoteConfig.fetchAndActivate();
    } on Object catch (e, s) {
      log('RemoteConfig: fetchAndActivate failed, using defaults', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> refresh() => _remoteConfig.fetchAndActivate();

  @override
  Stream<void> get updatesStream => _remoteConfig.onConfigUpdated.map<void>((_) {
    _remoteConfig.activate();
  });

  @override
  String getString(String key) => _remoteConfig.getString(key);

  @override
  bool getBool(String key) => _remoteConfig.getBool(key);

  @override
  int getInt(String key) => _remoteConfig.getInt(key);
}
