import "../../domain/repositories/storage_repository.dart";

class SecureStorage implements StorageRepository {
  const SecureStorage();

  @override
  Future<void> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<String?> read(String key) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> readAll() {
    // TODO: implement readAll
    throw UnimplementedError();
  }

  @override
  Future<void> write(String key, String value) {
    // TODO: implement write
    throw UnimplementedError();
  }
}
