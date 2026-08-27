import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "app_routes.dart";

/// Guards de navigation MagiCarré.
///
/// Chaque guard encapsule une règle d'accès. Le router les compose via
/// `runGuards` défini localement dans `app_router.dart` :
///
/// ```dart
/// Future<String?> runGuards(
///   BuildContext context,
///   GoRouterState state,
///   List<RouteGuard> guards,
/// ) async {
///   for (final guard in guards) {
///     if (!await guard.canActivate(context, state)) {
///       return guard.getRedirectPath(context, state);
///     }
///   }
///   return null;
/// }
/// ```
///
/// Exemple d'utilisation sur une `GoRoute` :
///
/// ```dart
/// GoRoute(
///   path: AppRoutes.game,
///   redirect: (context, state) => runGuards(context, state, [
///     AuthGuard(isAuthenticated: ref.read(authProvider).isAuthenticated),
///   ]),
///   builder: (context, state) => GamePage(
///     gameId: state.pathParameters['gameId']!,
///   ),
/// )
/// ```

/// Base abstraite d'un route guard.
abstract class RouteGuard {
  const RouteGuard();

  /// Retourne `true` si la navigation peut se poursuivre, `false` sinon.
  Future<bool> canActivate(BuildContext context, GoRouterState state);

  /// Chemin de redirection quand le guard bloque.
  String? getRedirectPath(BuildContext context, GoRouterState state);
}

/// Guard d'authentification — bloque l'accès aux routes protégées si
/// l'utilisateur n'est pas connecté et redirige vers la page de connexion.
class AuthGuard extends RouteGuard {
  const AuthGuard({required this.isAuthenticated});

  final bool isAuthenticated;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    return isAuthenticated;
  }

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) {
    return AppRoutes.authLogin;
  }
}

/// Guard d'onboarding — redirige vers l'onboarding si le joueur ne l'a
/// pas encore complété.
class OnboardingGuard extends RouteGuard {
  const OnboardingGuard({required this.onboardingCompleted});

  final bool onboardingCompleted;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    return onboardingCompleted;
  }

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) {
    return AppRoutes.onboarding;
  }
}

/// Guard de permission — vérifie qu'une permission spécifique est accordée
/// avant d'accéder à une fonctionnalité (ex. : modes de jeu premium,
/// création de tournoi, etc.).
class PermissionGuard extends RouteGuard {
  const PermissionGuard({
    required this.hasPermission,
    required this.requiredPermission,
  });

  final bool Function(String permission) hasPermission;
  final String requiredPermission;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    return hasPermission(requiredPermission);
  }

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) {
    return AppRoutes.home;
  }
}
