import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../data/datasources/prefs_storage.dart";
import "../../data/datasources/secure_storage.dart";
import "../../data/repositories/storage_repository_impl.dart";

part "storage_providers.g.dart";

/*
// Lire un token
final token = await ref.read(
    storageServiceProvider
  ).read(StorageKey.accessToken);

// Sauvegarder une préférence
await ref.read(storageServiceProvider).writeBool(
  StorageKey.onboardingCompleted,
  true,
);

// Sauvegarder un objet JSON
await ref.read(storageServiceProvider).writeJson(
  StorageKey.userPreferencesJson,
  prefs.toJson(),
);

// Logout — nettoyer uniquement les clés sensibles
await ref.read(storageServiceProvider).delete(StorageKey.accessToken);
await ref.read(storageServiceProvider).delete(StorageKey.refreshToken);
**/

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
