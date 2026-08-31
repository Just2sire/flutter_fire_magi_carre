import "dart:typed_data";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../../../../shared/presentation/providers/storage_providers.dart";
import "../../../../shared/presentation/providers/supabase_provider.dart";
import "../../data/datasources/auth_local_datasource.dart";
import "../../data/datasources/auth_remote_datasource_impl.dart";
import "../../data/repositories/auth_repository_impl.dart";
import "../../domain/entities/auth_event.dart";
import "../../domain/entities/auth_state.dart";
import "../../domain/entities/user_profile.dart";
import "../../domain/repositories/auth_repository.dart";
import "../../domain/usecases/complete_oauth_signin_usecase.dart";
import "../../domain/usecases/complete_onboarding_usecase.dart";
import "../../domain/usecases/login_usecase.dart";
import "../../domain/usecases/logout_usecase.dart";
import "../../domain/usecases/reset_password_use_case.dart";
import "../../domain/usecases/sign_in_with_github_usecase.dart";
import "../../domain/usecases/sign_in_with_google_usecase.dart";
import "../../domain/usecases/signup_usecase.dart";
import "../../domain/usecases/update_bio_usecase.dart";
import "../../domain/usecases/update_password_use_case.dart";
import "../../domain/usecases/update_username_usecase.dart";
import "../../domain/usecases/upload_avatar_usecase.dart";
import "../../domain/usecases/watch_auth_state_usecase.dart";

part "auth_providers.g.dart";

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------

/// Datasource Supabase Auth (GoTrue) + Google Sign-In natif.
@Riverpod(keepAlive: true)
AuthRemoteDataSourceImpl authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
}

/// Cache local de session (SharedPreferences).
@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSource(ref.watch(sharedPreferencesProvider));
}

/// Implémentation [AuthRepository] branchée sur Supabase + cache local.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
}

// ---------------------------------------------------------------------------
// Usecases
// ---------------------------------------------------------------------------

@riverpod
SignupUseCase signupUseCase(Ref ref) =>
    SignupUseCase(ref.watch(authRepositoryProvider));

@riverpod
LoginUseCase loginUseCase(Ref ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
LogoutUseCase logoutUseCase(Ref ref) =>
    LogoutUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) =>
    SignInWithGoogleUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignInWithGithubUseCase signInWithGithubUseCase(Ref ref) =>
    SignInWithGithubUseCase(ref.watch(authRepositoryProvider));

@riverpod
CompleteOAuthSignInUseCase completeOAuthSignInUseCase(Ref ref) =>
    CompleteOAuthSignInUseCase(ref.watch(authRepositoryProvider));

@riverpod
CompleteOnboardingUseCase completeOnboardingUseCase(Ref ref) =>
    CompleteOnboardingUseCase(ref.watch(authRepositoryProvider));

@riverpod
ResetPasswordUseCase resetPasswordUseCase(Ref ref) =>
    ResetPasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
UpdatePasswordUseCase updatePasswordUseCase(Ref ref) =>
    UpdatePasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
UpdateBioUseCase updateBioUseCase(Ref ref) =>
    UpdateBioUseCase(ref.watch(authRepositoryProvider));

@riverpod
UpdateUsernameUseCase updateUsernameUseCase(Ref ref) =>
    UpdateUsernameUseCase(ref.watch(authRepositoryProvider));

@riverpod
UploadAvatarUseCase uploadAvatarUseCase(Ref ref) =>
    UploadAvatarUseCase(ref.watch(authRepositoryProvider));

@riverpod
WatchAuthStateUseCase watchAuthStateUseCase(Ref ref) =>
    WatchAuthStateUseCase(ref.watch(authRepositoryProvider));

// ---------------------------------------------------------------------------
// Auth notifier
// ---------------------------------------------------------------------------

/// Notifier central de l'état d'authentification.
///
/// - Restaure la session au démarrage depuis le cache local.
/// - Écoute [WatchAuthStateUseCase] pour détecter les callbacks OAuth.
/// - Expose des méthodes d'action (signup, login, OAuth, logout, onboarding).
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Abonnement au stream Supabase pour détecter les callbacks OAuth.
    final subscription = ref
        .read(watchAuthStateUseCaseProvider)
        .call()
        .listen(_onAuthEvent);
    ref.onDispose(subscription.cancel);

    final localDs = ref.read(authLocalDataSourceProvider);

    if (!localDs.hasSession()) {
      return const AuthUnauthenticated();
    }

    // Session locale détectée — vérification async avec Supabase.
    Future.microtask(_restoreSession);
    return const AuthLoading();
  }

  /// Vérifie la validité de la session Supabase et charge le profil.
  Future<void> _restoreSession() async {
    final result = await ref.read(authRepositoryProvider).fetchCurrentProfile();
    state = result.fold(
      (_) => const AuthUnauthenticated(),
      AuthAuthenticated.new,
    );
  }

  /// Réagit aux événements du stream d'auth Supabase.
  void _onAuthEvent(AuthEvent event) {
    switch (event) {
      case AuthEvent.signedIn:
        // Callback OAuth reçu — finaliser la création du profil.
        if (state is AuthOAuthPending) _completeOAuthFlow();
      case AuthEvent.signedOut:
        state = const AuthUnauthenticated();
      case AuthEvent.passwordRecovery:
        state = const AuthPasswordRecovery();
      case AuthEvent.initialSession:
      case AuthEvent.tokenRefreshed:
      case AuthEvent.userUpdated:
        break;
    }
  }

  Future<void> _completeOAuthFlow() async {
    state = const AuthLoading();
    final result = await ref.read(completeOAuthSignInUseCaseProvider).call();
    state = result.fold(AuthFailureState.new, AuthAuthenticated.new);
  }

  // -------------------------------------------------------------------------
  // Actions publiques
  // -------------------------------------------------------------------------

  Future<void> signup(
    String email,
    String password, {
    String? username,
  }) async {
    state = const AuthLoading();
    final result = await ref
        .read(signupUseCaseProvider)
        .call(email, password, username: username);
    state = result.fold(AuthFailureState.new, AuthAuthenticated.new);
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    final result = await ref
        .read(loginUseCaseProvider)
        .call(email, password);
    state = result.fold(AuthFailureState.new, AuthAuthenticated.new);
  }

  /// Lance le flow OAuth Google.
  ///
  /// L'état passe à [AuthOAuthPending]. La finalisation arrive via
  /// [_onAuthEvent] quand Supabase reçoit le callback deep-link.
  Future<void> signInWithGoogle() async {
    state = const AuthOAuthPending();
    final result = await ref.read(signInWithGoogleUseCaseProvider).call();
    result.fold(
      (failure) => state = AuthFailureState(failure),
      (_) {}, // Reste AuthOAuthPending — résolu par _onAuthEvent
    );
  }

  /// Lance le flow OAuth GitHub.
  Future<void> signInWithGithub() async {
    state = const AuthOAuthPending();
    final result = await ref.read(signInWithGithubUseCaseProvider).call();
    result.fold(
      (failure) => state = AuthFailureState(failure),
      (_) {},
    );
  }

  Future<void> logout() async {
    state = const AuthLoading();
    final result = await ref.read(logoutUseCaseProvider).call();
    state = result.fold(
      AuthFailureState.new,
      (_) => const AuthUnauthenticated(),
    );
  }

  /// Passe en mode invité — accès à l'app sans authentification, à la
  /// demande explicite de l'utilisateur (bouton "Continuer sans compte").
  void skipAuth() => state = const AuthGuest();

  /// Met à jour la bio du profil courant.
  ///
  /// Contrairement à [login]/[signup], un échec ne fait PAS basculer
  /// `state` vers [AuthFailureState] — l'utilisateur reste authentifié,
  /// l'erreur est simplement renvoyée à l'appelant pour affichage local.
  Future<Either<Failure, UserProfile>> updateBio(String bio) async {
    final result = await ref.read(updateBioUseCaseProvider).call(bio);
    result.fold((_) {}, (profile) => state = AuthAuthenticated(profile));
    return result;
  }

  /// Met à jour le nom d'utilisateur du profil courant. Voir [updateBio]
  /// pour la sémantique d'échec (ne déauthentifie jamais l'utilisateur).
  Future<Either<Failure, UserProfile>> updateUsername(String username) async {
    final result = await ref.read(updateUsernameUseCaseProvider).call(username);
    result.fold((_) {}, (profile) => state = AuthAuthenticated(profile));
    return result;
  }

  /// Upload une nouvelle image d'avatar et met à jour le profil courant.
  /// Voir [updateBio] pour la sémantique d'échec.
  Future<Either<Failure, UserProfile>> uploadAvatar(
    Uint8List bytes,
    String fileExtension,
  ) async {
    final result = await ref
        .read(uploadAvatarUseCaseProvider)
        .call(bytes, fileExtension);
    result.fold((_) {}, (profile) => state = AuthAuthenticated(profile));
    return result;
  }

  /// Marque l'onboarding comme terminé et met à jour le profil en state.
  Future<void> completeOnboarding() async {
    final result = await ref.read(completeOnboardingUseCaseProvider).call();
    result.fold(
      (failure) => state = AuthFailureState(failure),
      (profile) => state = AuthAuthenticated(profile),
    );
  }
}
