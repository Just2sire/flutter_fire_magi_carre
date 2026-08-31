import "failure.dart";

/// Échec de lecture / écriture en cache local (Isar, SharedPreferences,
/// FlutterSecureStorage).
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.cause});
}
