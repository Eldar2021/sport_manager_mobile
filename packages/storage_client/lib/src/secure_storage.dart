import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:storage_client/src/exceptions/storage_exception.dart';
import 'package:storage_client/src/interface/storage_interface.dart';

/// Hardware-backed key/value storage for sensitive data (auth tokens, PIN).
///
/// Backed by iOS Keychain (`first_unlock_this_device` accessibility, so values
/// stay on-device and are excluded from iCloud backups) and on Android by the
/// package's default custom-cipher backing store (as of flutter_secure_storage
/// v10 — the old Jetpack `EncryptedSharedPreferences` path is deprecated and
/// migrated automatically on first access).
class SecureStorage implements StorageInterface {
  const SecureStorage([
    this._secureStorage = const FlutterSecureStorage(
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  ]);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<String?> read(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> write({required String key, required String value}) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _secureStorage.deleteAll();
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace: stackTrace);
    }
  }
}
