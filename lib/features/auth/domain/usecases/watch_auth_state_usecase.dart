import "../entities/auth_event.dart";
import "../repositories/auth_repository.dart";

/// Observe les changements d'état d'authentification Supabase.
///
/// Émet un [AuthEvent] à chaque changement de session : connexion,
/// déconnexion, retour OAuth, refresh de token. À consommer via
/// le notifier d'auth pour piloter l'état global.
class WatchAuthStateUseCase {
  const WatchAuthStateUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AuthEvent> call() => _repository.watchAuthState();
}
