import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../../features/auth/presentation/pages/index.dart";
import "../../features/welcome/presentation/pages/index.dart";
import "../configs/env.dart";
import "../constants/app_icons.dart";
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
GoRouter buildRouter() => GoRouter(
  navigatorKey: AppNavigatorKey.instance,
  debugLogDiagnostics: Env.enableLogging,
  initialLocation: AppRoutes.root,
  errorBuilder: (context, state) => const _RouterErrorPage(),
  redirect: (context, state) {
    // Phase 2 : brancher AuthGuard + OnboardingGuard ici.
    return null;
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

    // ─── Partie — plein écran hors-shell ──────
    GoRoute(
      path: AppRoutes.game,
      parentNavigatorKey: AppNavigatorKey.instance,
      pageBuilder: (context, state) => AppTransitions.slide(
        context: context,
        state: state,
        begin: const Offset(0.0, 1.0), // monte depuis le bas
        child: _Placeholder(title: "Partie ${state.pathParameters['gameId']}"),
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
        child: const _Placeholder(title: "Paramètres"),
      ),
    ),

    // ─── Shell — bottom navigation bar ────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _ShellScaffold(navigationShell: navigationShell),
      branches: [
        // Branche 1 : Accueil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) => AppTransitions.fade(
                context: context,
                state: state,
                child: const _Placeholder(title: "Accueil"),
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
                  pageBuilder: (context, state) => AppTransitions.pushedScreen(
                    context: context,
                    state: state,
                    child: const _Placeholder(title: "Créer une partie"),
                  ),
                ),
                GoRoute(
                  path: "join/:inviteCode",
                  pageBuilder: (context, state) => AppTransitions.pushedScreen(
                    context: context,
                    state: state,
                    child: _Placeholder(
                      title: "Rejoindre ${state.pathParameters['inviteCode']}",
                    ),
                  ),
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
                child: const _Placeholder(title: "Classement"),
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
                child: const _Placeholder(title: "Profil"),
              ),
              routes: [
                GoRoute(
                  path: "edit",
                  pageBuilder: (context, state) => AppTransitions.pushedScreen(
                    context: context,
                    state: state,
                    child: const _Placeholder(title: "Modifier le profil"),
                  ),
                ),
                GoRoute(
                  path: "change-password",
                  pageBuilder: (context, state) => AppTransitions.pushedScreen(
                    context: context,
                    state: state,
                    child: const _Placeholder(
                      title: "Modifier le mot de passe",
                    ),
                  ),
                ),
                GoRoute(
                  path: "history",
                  pageBuilder: (context, state) => AppTransitions.pushedScreen(
                    context: context,
                    state: state,
                    child: const _Placeholder(title: "Historique"),
                  ),
                ),
                GoRoute(
                  path: "friends/:userId",
                  pageBuilder: (context, state) => AppTransitions.pushedScreen(
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

// ─── Shell scaffold ────────────────────────────────────────────────────────

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(AppIcons.navHome), label: "Accueil"),
          NavigationDestination(icon: Icon(AppIcons.navLobby), label: "Lobby"),
          NavigationDestination(
            icon: Icon(AppIcons.navLeaderboard),
            label: "Classement",
          ),
          NavigationDestination(
            icon: Icon(AppIcons.navProfile),
            label: "Profil",
          ),
        ],
      ),
    );
  }
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
