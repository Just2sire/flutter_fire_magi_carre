import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../features/auth/domain/entities/auth_state.dart";
import "../../features/auth/presentation/pages/index.dart";
import "../../features/auth/presentation/providers/auth_providers.dart";
import "../../features/game/presentation/pages/index.dart";
import "../../features/leaderboard/presentation/pages/leaderboard_page.dart";
import "../../features/profile/presentation/pages/index.dart";
import "../../features/settings/presentation/pages/index.dart";
import "../../features/welcome/presentation/pages/index.dart";
import "../../shared/presentation/pages/app_shell.dart";
import "../configs/env.dart";
import "../constants/app_icons.dart";
import "../extensions/navigation_extensions.dart";
import "../theme/index.dart" show AppSpacing, AppColors;
import "app_navigator_key.dart";
import "app_routes.dart";
import "app_transitions.dart";

/// GoRouter global de MagiCarré.
///
/// Structure :
/// - Routes hors-shell : `/`, `/onboarding`, `/auth/**`.
/// - Routes hors-shell plein écran : `/game/:gameId`, `/game/:gameId/result`,
///   `/learn`, `/learn/:chapterId`, `/settings`.
/// - `StatefulShellRoute.indexedStack` à 4 branches :
///   `/home`, `/lobby`, `/leaderboard`, `/profile`.
///
/// Le redirect sera câblé en Phase 2 (auth + onboarding via guards).
GoRouter buildRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier();

  ref
    ..listen<AuthState>(authProvider, (_, _) => refreshNotifier.notify())
    ..onDispose(refreshNotifier.dispose);

  return GoRouter(
    navigatorKey: AppNavigatorKey.instance,
    debugLogDiagnostics: Env.enableLogging,
    initialLocation: AppRoutes.root,
    refreshListenable: refreshNotifier,
    errorBuilder: (context, state) => const _RouterErrorPage(),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.matchedLocation;

      final isAuthRoute = location.startsWith("/auth");
      final isBootstrapRoute =
          location == AppRoutes.root || location == AppRoutes.onboarding;

      return switch (authState) {
        AuthLoading() =>
          isAuthRoute || isBootstrapRoute ? null : AppRoutes.root,
        AuthUnauthenticated() || AuthFailureState() =>
          isAuthRoute || isBootstrapRoute ? null : AppRoutes.authLogin,
        AuthOAuthPending() => null,
        AuthPasswordRecovery() =>
          location == AppRoutes.authResetPassword
              ? null
              : AppRoutes.authResetPassword,
        AuthAuthenticated() ||
        AuthGuest() => isAuthRoute || isBootstrapRoute ? AppRoutes.home : null,
      };
    },
    routes: [
      // ─── Splash ───────────────────────────────
      GoRoute(
        path: AppRoutes.root,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const SplashPage(),
        ),
      ),

      // ─── Onboarding ───────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const OnboardingPage(),
        ),
      ),

      // ─── Auth ─────────────────────────────────
      GoRoute(
        path: AppRoutes.authLogin,
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          context: context,
          state: state,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authSignup,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authForgot,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: const ForgotPassword(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authResetPassword,
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          context: context,
          state: state,
          child: const ResetPassword(),
        ),
      ),

      // ─── Lobby de partie ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.gameLobby,
        parentNavigatorKey: AppNavigatorKey.instance,
        pageBuilder: (context, state) => AppTransitions.slide(
          context: context,
          state: state,
          begin: const Offset(0.0, 1.0),
          child: const GameLobbyPage(),
        ),
      ),

      // ─── Partie locale — solo vs IA ────────────
      GoRoute(
        path: AppRoutes.gameLocal,
        parentNavigatorKey: AppNavigatorKey.instance,
        pageBuilder: (context, state) => AppTransitions.slide(
          context: context,
          state: state,
          begin: const Offset(0.0, 1.0), // monte depuis le bas
          child: const GamePage(),
        ),
      ),

      // ─── Partie — plein écran hors-shell ──────
      GoRoute(
        path: AppRoutes.game,
        parentNavigatorKey: AppNavigatorKey.instance,
        pageBuilder: (context, state) => AppTransitions.slide(
          context: context,
          state: state,
          begin: const Offset(0.0, 1.0), // monte depuis le bas
          child: _Placeholder(
            title: "Partie ${state.pathParameters['gameId']}",
          ),
        ),
        routes: [
          GoRoute(
            path: "result",
            pageBuilder: (context, state) => AppTransitions.fadeScale(
              context: context,
              state: state,
              child: _Placeholder(
                title: "Résultat ${state.pathParameters['gameId']}",
              ),
            ),
          ),
        ],
      ),

      // ─── Apprendre — hors-shell ───────────────
      GoRoute(
        path: AppRoutes.learn,
        parentNavigatorKey: AppNavigatorKey.instance,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: const _Placeholder(title: "Apprendre"),
        ),
        routes: [
          GoRoute(
            path: ":chapterId",
            pageBuilder: (context, state) => AppTransitions.pushedScreen(
              context: context,
              state: state,
              child: _Placeholder(
                title: "Chapitre ${state.pathParameters['chapterId']}",
              ),
            ),
          ),
        ],
      ),

      // ─── Paramètres — hors-shell ──────────────
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: AppNavigatorKey.instance,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: const SettingsPage(),
        ),
      ),

      // ─── Shell — bottom navigation bar ────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Branche 1 : Accueil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  // TODO: retirer une fois un vrai écran d'accueil construit.
                  child: const _HomePlaceholder(),
                ),
              ),
            ],
          ),

          // Branche 2 : Lobby
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.lobby,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const _Placeholder(title: "Lobby"),
                ),
                routes: [
                  GoRoute(
                    path: "create",
                    pageBuilder: (context, state) =>
                        AppTransitions.pushedScreen(
                          context: context,
                          state: state,
                          child: const _Placeholder(title: "Créer une partie"),
                        ),
                  ),
                  GoRoute(
                    path: "join/:inviteCode",
                    pageBuilder: (context, state) {
                      return AppTransitions.pushedScreen(
                        context: context,
                        state: state,
                        child: _Placeholder(
                          title:
                              "Rejoindre ${state.pathParameters['inviteCode']}",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branche 3 : Classement
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderboard,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const LeaderboardPage(),
                ),
              ),
            ],
          ),

          // Branche 4 : Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const ProfilePage(),
                ),
                routes: [
                  GoRoute(
                    path: "edit",
                    pageBuilder: (context, state) =>
                        AppTransitions.pushedScreen(
                          context: context,
                          state: state,
                          child: const ProfileEditPage(),
                        ),
                  ),
                  GoRoute(
                    path: "change-password",
                    pageBuilder: (context, state) =>
                        AppTransitions.pushedScreen(
                          context: context,
                          state: state,
                          child: const ProfileChangePasswordPage(),
                        ),
                  ),
                  GoRoute(
                    path: "history",
                    pageBuilder: (context, state) =>
                        AppTransitions.pushedScreen(
                          context: context,
                          state: state,
                          child: const _Placeholder(title: "Historique"),
                        ),
                  ),
                  GoRoute(
                    path: "friends/:userId",
                    pageBuilder: (context, state) =>
                        AppTransitions.pushedScreen(
                          context: context,
                          state: state,
                          child: _Placeholder(
                            title: "Joueur ${state.pathParameters['userId']}",
                          ),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// ─── Widgets utilitaires ───────────────────────────────────────────────────

/// Écran temporaire affiché en attendant l'implémentation réelle de la page.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), elevation: 0),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingH,
          child: Text(
            "$title — bientôt.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

/// Placeholder de l'accueil — avec un bouton "Jouer" temporaire vers la
/// partie locale, en attendant un vrai écran d'accueil.
class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accueil"), elevation: 0),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingH,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Accueil — bientôt.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              AppSpacing.gapVLg,
              ElevatedButton(
                onPressed: () => context.pushGameLobby<void>(),
                child: const Text("Jouer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Écran d'erreur affiché quand GoRouter ne trouve pas de route correspondante.
class _RouterErrorPage extends StatelessWidget {
  const _RouterErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(AppIcons.arrowLeft),
        ),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingH,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Cet écran n'existe pas encore.",
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVSm,
              Text(
                "Reviens plus tard, ou reprends depuis l'accueil.",
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Router refresh ────────────────────────────────────────────────────────

/// Notifie GoRouter de réévaluer le redirect quand l'AuthState change.
class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// Extensions de navigation impérative sur GoRouter.
extension GoRouterExtension on GoRouter {
  void goAndClearStack(String location) {
    while (canPop()) {
      pop();
    }
    go(location);
  }

  Future<T?> pushWithResult<T>(String location, {Object? extra}) {
    return push<T>(location, extra: extra);
  }
}
