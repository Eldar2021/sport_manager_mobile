import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_client/src/exceptions/storage_exception.dart';
import 'package:storage_client/src/interface/storage_sync_read_interface.dart';

class PreferencesStorage implements StorageInterfaceSyncRead {
  const PreferencesStorage._(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  static Future<PreferencesStorage> getInstance([
    SharedPreferences? pref,
  ]) async {
    return PreferencesStorage._(pref ?? await SharedPreferences.getInstance());
  }

  @override
  String? readString(String key) {
    try {
      return _sharedPreferences.getString(key);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  bool? readBool(String key) {
    try {
      return _sharedPreferences.getBool(key);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  double? readDouble(String key) {
    try {
      return _sharedPreferences.getDouble(key);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  int? readInt(String key) {
    try {
      return _sharedPreferences.getInt(key);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  List<String>? readStringList(String key) {
    try {
      return _sharedPreferences.getStringList(key);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  Future<bool> writeString({
    required String key,
    required String value,
  }) {
    try {
      return _sharedPreferences.setString(key, value);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  Future<bool> writeBool({
    required String key,
    required bool value,
  }) {
    try {
      return _sharedPreferences.setBool(key, value);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  Future<bool> writeDouble({
    required String key,
    required double value,
  }) {
    try {
      return _sharedPreferences.setDouble(key, value);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  Future<bool> writeInt({
    required String key,
    required int value,
  }) {
    try {
      return _sharedPreferences.setInt(key, value);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  Future<bool> writeStringList({
    required String key,
    required List<String> value,
  }) {
    try {
      return _sharedPreferences.setStringList(key, value);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  Future<bool> delete(String key) {
    try {
      return _sharedPreferences.remove(key);
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }

  @override
  Future<bool> clear() {
    try {
      return _sharedPreferences.clear();
    } catch (error, s) {
      throw StorageException(error, stackTrace: s);
    }
  }
}
