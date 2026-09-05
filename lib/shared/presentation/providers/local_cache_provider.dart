import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../data/services/local_cache_service.dart";

part "local_cache_provider.g.dart";

// Instance injectée depuis main() — pas d'async dans le provider.
@Riverpod(keepAlive: true)
LocalCacheService localCacheService(Ref ref) {
  throw UnimplementedError("Override in main via ProviderScope");
}
