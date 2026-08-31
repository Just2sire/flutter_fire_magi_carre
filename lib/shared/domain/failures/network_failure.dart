import "failure.dart";

/// Pas de connexion réseau, timeout, ou erreur DNS.
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.cause});
}
