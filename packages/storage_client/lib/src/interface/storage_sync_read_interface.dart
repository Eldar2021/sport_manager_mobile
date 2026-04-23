abstract class StorageInterfaceSyncRead {
  String? readString(String key);

  bool? readBool(String key);

  double? readDouble(String key);

  int? readInt(String key);

  List<String>? readStringList(String key);

  Future<bool> writeString({
    required String key,
    required String value,
  });

  Future<bool> writeBool({
    required String key,
    required bool value,
  });

  Future<bool> writeDouble({
    required String key,
    required double value,
  });

  Future<bool> writeInt({
    required String key,
    required int value,
  });

  Future<bool> writeStringList({
    required String key,
    required List<String> value,
  });

  Future<bool> delete(String key);

  Future<bool> clear();
}
