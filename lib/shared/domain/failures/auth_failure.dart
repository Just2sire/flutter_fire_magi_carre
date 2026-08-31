import "failure.dart";

/// Credentials invalides (email/mot de passe incorrect).
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    super.message = "Identifiants invalides",
    super.cause,
  });
}

/// Session expirée — refresh token épuisé ou révoqué.
class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({
    super.message = "Session expirée, veuillez vous reconnecter",
    super.cause,
  });
}

/// Accès refusé — token valide mais permissions insuffisantes (403).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = "Accès non autorisé",
    super.cause,
  });
}

/// L'utilisateur a fermé le sélecteur de compte Google sans se connecter.
///
/// À distinguer des autres échecs : ce n'est pas une erreur à afficher,
/// juste une annulation volontaire du flow.
class GoogleSignInCancelledFailure extends Failure {
  const GoogleSignInCancelledFailure({
    super.message = "Connexion Google annulée",
    super.cause,
  });
}

/// L'utilisateur a annulé un flow OAuth (Google, GitHub, Apple).
class OAuthCancelledFailure extends Failure {
  const OAuthCancelledFailure({
    super.message = "Connexion OAuth annulée",
    super.cause,
  });
}

/// Le nom d'utilisateur choisi est déjà pris par un autre compte.
class UsernameTakenFailure extends Failure {
  const UsernameTakenFailure({
    super.message = "Nom d'utilisateur déjà pris",
    super.cause,
  });
}

/// Profil utilisateur introuvable — l'entrée n'existe pas en base.
class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure({
    super.message = "Utilisateur introuvable",
    super.cause,
  });
}
