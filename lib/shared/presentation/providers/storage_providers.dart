import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../data/datasources/prefs_storage.dart";
import "../../data/datasources/secure_storage.dart";
import "../../data/repositories/storage_repository_impl.dart";

part "storage_providers.g.dart";

// SharedPreferences injecté depuis main() — pas d'async dans le provider
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError("Override in main via ProviderScope");
}

// FlutterSecureStorage — config Android recommandée
@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) {
  return const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
}

// Façade unique
@Riverpod(keepAlive: true)
StorageRepositoryImpl storageService(Ref ref) {
  return StorageRepositoryImpl(
    secure: SecureStorage(ref.watch(flutterSecureStorageProvider)),
    regular: PrefsStorage(ref.watch(sharedPreferencesProvider)),
  );
}
