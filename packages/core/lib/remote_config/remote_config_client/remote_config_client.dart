abstract interface class RemoteConfigClient {
  Future<void> init(Map<String, String> defaults);

  Future<void> refresh();

  Stream<void> get updatesStream;

  String getString(String key);

  bool getBool(String key);

  int getInt(String key);
}
