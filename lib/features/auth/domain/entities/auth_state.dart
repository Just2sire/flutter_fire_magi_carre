import "../../../../shared/domain/failures/failure.dart";
import "user_profile.dart";

/// État courant de l'authentification exposé par le notifier d'auth.
sealed class AuthState {
  const AuthState();
}

/// Vérification de session en cours au démarrage.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Aucune session active — utilisateur non connecté.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Flow OAuth ouvert dans le navigateur — en attente du callback deep-link.
class AuthOAuthPending extends AuthState {
  const AuthOAuthPending();
}

/// Session active avec profil complet.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.profile);

  final UserProfile profile;
}

/// Lien de réinitialisation reçu — session temporaire active, en attente
/// du nouveau mot de passe.
class AuthPasswordRecovery extends AuthState {
  const AuthPasswordRecovery();
}

/// L'utilisateur a choisi de continuer sans compte — accès à l'app sans
/// session Supabase active.
class AuthGuest extends AuthState {
  const AuthGuest();
}

/// Une opération d'auth a échoué.
class AuthFailureState extends AuthState {
  const AuthFailureState(this.failure);

  final Failure failure;
}
