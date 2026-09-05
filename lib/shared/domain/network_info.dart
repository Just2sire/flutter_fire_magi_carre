/// Vérifie l'état de la connexion réseau — abstraction testable, découplée
/// de `connectivity_plus` pour que les repositories restent mockables.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}
