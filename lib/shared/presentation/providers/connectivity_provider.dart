import "package:connectivity_plus/connectivity_plus.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "connectivity_provider.g.dart";

/// Stream des changements de connectivité.
@Riverpod(keepAlive: true)
Stream<List<ConnectivityResult>> connectivityStatus(Ref ref) =>
    Connectivity().onConnectivityChanged;

/// `true` si au moins une interface réseau est active.
@Riverpod(keepAlive: true)
bool isOnline(Ref ref) {
  final result =
      ref.watch(connectivityStatusProvider).asData?.value;
  if (result == null) return true; // optimiste au démarrage
  return result.any((r) => r != ConnectivityResult.none);
}
