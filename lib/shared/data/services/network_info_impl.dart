import "package:connectivity_plus/connectivity_plus.dart";

import "../../domain/network_info.dart";

/// Implémentation [NetworkInfo] basée sur `connectivity_plus`.
class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl();

  @override
  Future<bool> get isConnected async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
