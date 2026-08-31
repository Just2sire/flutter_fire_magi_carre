import "failure.dart";

/// Validation côté client échouée — champs de formulaire invalides.
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldErrors,
    super.cause,
  });

  /// Erreurs par champ : `{'email': 'Format invalide', 'password': '...'}`.
  final Map<String, String>? fieldErrors;
}
