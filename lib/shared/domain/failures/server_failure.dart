import "failure.dart";

/// Réponse 5xx ou corps malformé côté serveur.
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    this.statusCode,
    super.cause,
  });

  final int? statusCode;
}
