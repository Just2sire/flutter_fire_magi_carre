import "package:flutter_secure_storage/flutter_secure_storage.dart";

import "../../domain/repositories/storage_repository.dart";

class SecureStorage implements StorageRepository {
  const SecureStorage(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();

  @override
  Future<Map<String, String>> readAll() => _storage.readAll();
}
