/// Chemins de routes MagiCarré.
class AppRoutes {
  AppRoutes._();

  // ─── Bootstrap ────────────────────────────
  static const String root = "/";
  static const String onboarding = "/onboarding";

  // ─── Auth ─────────────────────────────────
  static const String authLogin = "/auth/login";
  static const String authSignup = "/auth/signup";
  static const String authForgot = "/auth/forgot";
  static const String authResetPassword = "/auth/reset-password";

  // ─── Onglets shell (bottom nav) ───────────
  static const String home = "/home";
  static const String lobby = "/lobby";
  static const String leaderboard = "/leaderboard";
  static const String profile = "/profile";

  // ─── Partie — flow principal ──────────────
  static const String game = "/game/:gameId";
  static const String gameResult = "/game/:gameId/result";

  // ─── Partie locale — solo vs IA ───────────
  static const String gameLobby = "/game/lobby";
  static const String gameLocal = "/game/local";

  // ─── Lobby — sous-écrans ──────────────────
  static const String lobbyCreate = "/lobby/create";
  static const String lobbyJoin = "/lobby/join/:inviteCode";

  // ─── Apprendre — règles & tutoriels ───────
  static const String learn = "/learn";
  static const String learnChapter = "/learn/:chapterId";

  // ─── Profil — sous-écrans ─────────────────
  static const String profileEdit = "/profile/edit";
  static const String profileChangePassword = "/profile/change-password";
  static const String profileHistory = "/profile/history";
  static const String friendProfile = "/profile/friends/:userId";

  // ─── Paramètres ───────────────────────────
  static const String settings = "/settings";

  // ─── Helpers de construction ───────────────
  static String gamePath(String gameId) => "/game/$gameId";
  static String gameResultPath(String gameId) => "/game/$gameId/result";
  static String lobbyJoinPath(String inviteCode) => "/lobby/join/$inviteCode";
  static String learnChapterPath(String chapterId) => "/learn/$chapterId";
  static String friendProfilePath(String userId) => "/profile/friends/$userId";
}
