import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../features/auth/domain/entities/auth_state.dart";
import "../../features/auth/presentation/providers/auth_providers.dart";
import "../../features/auth/presentation/widgets/auth_gate_sheet.dart";
import "../routing/app_routes.dart";

/// Extensions de navigation MagiCarré — enveloppent GoRouter avec les
/// destinations métier de l'app.
///
/// Chaque route expose deux variantes :
/// - `go*` — remplace la pile de navigation (navigation racine / onglets).
/// - `push*` — empile la destination par-dessus l'écran courant.
extension NavigationExtensions on BuildContext {

  // ─── Bootstrap ────────────────────────────

  void goRoot() => go(AppRoutes.root);
  Future<T?> pushRoot<T>() => push<T>(AppRoutes.root);

  void goOnboarding() => go(AppRoutes.onboarding);
  Future<T?> pushOnboarding<T>() => push<T>(AppRoutes.onboarding);

  // ─── Auth ─────────────────────────────────

  void goAuthLogin() => go(AppRoutes.authLogin);
  Future<T?> pushAuthLogin<T>() => push<T>(AppRoutes.authLogin);

  void goAuthSignup() => go(AppRoutes.authSignup);
  Future<T?> pushAuthSignup<T>() => push<T>(AppRoutes.authSignup);

  void goAuthForgot() => go(AppRoutes.authForgot);
  Future<T?> pushAuthForgot<T>() => push<T>(AppRoutes.authForgot);

  void goAuthResetPassword() => go(AppRoutes.authResetPassword);
  Future<T?> pushAuthResetPassword<T>() =>
      push<T>(AppRoutes.authResetPassword);

  // ─── Onglets shell ────────────────────────

  void goHome() => go(AppRoutes.home);
  Future<T?> pushHome<T>() => push<T>(AppRoutes.home);

  void goLobby() => go(AppRoutes.lobby);
  Future<T?> pushLobby<T>() => push<T>(AppRoutes.lobby);

  void goLeaderboard() => go(AppRoutes.leaderboard);
  Future<T?> pushLeaderboard<T>() => push<T>(AppRoutes.leaderboard);

  void goProfile() => go(AppRoutes.profile);
  Future<T?> pushProfile<T>() => push<T>(AppRoutes.profile);

  // ─── Partie ───────────────────────────────

  void goGame(String gameId) => go(AppRoutes.gamePath(gameId));
  Future<T?> pushGame<T>(String gameId) => push<T>(AppRoutes.gamePath(gameId));

  void goGameResult(String gameId) => go(AppRoutes.gameResultPath(gameId));
  Future<T?> pushGameResult<T>(String gameId) =>
      push<T>(AppRoutes.gameResultPath(gameId));

  void goGameLobby() => go(AppRoutes.gameLobby);
  Future<T?> pushGameLobby<T>() => push<T>(AppRoutes.gameLobby);

  void goGameLocal({Object? extra}) => go(AppRoutes.gameLocal, extra: extra);
  Future<T?> pushGameLocal<T>({Object? extra}) =>
      push<T>(AppRoutes.gameLocal, extra: extra);

  void goGameOnline(String matchId) =>
      go(AppRoutes.gameOnlinePath(matchId));
  Future<T?> pushGameOnline<T>(String matchId) =>
      push<T>(AppRoutes.gameOnlinePath(matchId));

  // ─── Lobby — sous-écrans ──────────────────

  void goLobbyCreate() => go(AppRoutes.lobbyCreate);
  Future<T?> pushLobbyCreate<T>() => push<T>(AppRoutes.lobbyCreate);

  void goLobbyJoin(String inviteCode) =>
      go(AppRoutes.lobbyJoinPath(inviteCode));
  Future<T?> pushLobbyJoin<T>(String inviteCode) =>
      push<T>(AppRoutes.lobbyJoinPath(inviteCode));

  // ─── Apprendre ────────────────────────────

  void goLearn() => go(AppRoutes.learn);
  Future<T?> pushLearn<T>() => push<T>(AppRoutes.learn);

  void goLearnChapter(String chapterId) =>
      go(AppRoutes.learnChapterPath(chapterId));
  Future<T?> pushLearnChapter<T>(String chapterId) =>
      push<T>(AppRoutes.learnChapterPath(chapterId));

  // ─── Profil — sous-écrans ─────────────────

  void goProfileEdit() => go(AppRoutes.profileEdit);
  Future<T?> pushProfileEdit<T>() => push<T>(AppRoutes.profileEdit);

  void goProfileChangePassword() => go(AppRoutes.profileChangePassword);
  Future<T?> pushProfileChangePassword<T>() =>
      push<T>(AppRoutes.profileChangePassword);

  void goProfileHistory() => go(AppRoutes.profileHistory);
  Future<T?> pushProfileHistory<T>() => push<T>(AppRoutes.profileHistory);

  void goFriendProfile(String userId) =>
      go(AppRoutes.friendProfilePath(userId));
  Future<T?> pushFriendProfile<T>(String userId) =>
      push<T>(AppRoutes.friendProfilePath(userId));

  // ─── Paramètres ───────────────────────────

  void goSettings() => go(AppRoutes.settings);
  Future<T?> pushSettings<T>() => push<T>(AppRoutes.settings);

  // ─── Retour ───────────────────────────────

  void popScreen<T extends Object?>([T? result]) {
    if (canPop()) pop<T>(result);
  }

  // ─── Auth gate ────────────────────────────

  /// Exécute [action] si l'utilisateur est authentifié, sinon affiche le
  /// bottom sheet [AuthGateSheet] d'invite à la connexion.
  ///
  /// Retourne `true` si l'action a été déclenchée (utilisateur déjà connecté
  /// ou connexion réussie via le sheet), `false` sinon.
  Future<bool> requireAuth(WidgetRef ref, VoidCallback action) async {
    final authState = ref.read(authProvider);
    if (authState is AuthAuthenticated) {
      action();
      return true;
    }
    final didAuth = await showModalBottomSheet<bool>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AuthGateSheet(),
    );
    if (didAuth == true) {
      action();
      return true;
    }
    return false;
  }
}
