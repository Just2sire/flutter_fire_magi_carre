import "failure.dart";

/// Traitement OCR Mistral insuffisant — confiance < 0.5, schéma JSON invalide,
/// ou timeout OCR spécifique.
class OcrProcessingFailure extends Failure {
  const OcrProcessingFailure({
    required super.message,
    this.confidence,
    super.cause,
  });

  /// Score de confiance retourné par Mistral (entre 0 et 1). `null` si l'erreur
  /// est structurelle (schéma invalide, timeout) plutôt que de qualité.
  final double? confidence;
}
