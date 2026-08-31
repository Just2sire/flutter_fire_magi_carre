/// Événements d'authentification émis par Supabase, mappés en types domaine.
enum AuthEvent {
  initialSession,
  signedIn,
  signedOut,
  passwordRecovery,
  tokenRefreshed,
  userUpdated,
}
