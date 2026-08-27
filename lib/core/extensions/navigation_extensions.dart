import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";

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
}
