// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// État d'une partie en cours, câblé sur le moteur pur `carre_magic_logic`.
///
/// Portée par partie (pas `keepAlive`) : quand l'écran de jeu qui l'observe
/// est démonté, la partie en cours est abandonnée — pas de persistance ici,
/// c'est un choix pour une future couche data (local ou Supabase Realtime
/// pour le multijoueur), hors périmètre de ce câblage.

@ProviderFor(GameNotifier)
final gameProvider = GameNotifierProvider._();

/// État d'une partie en cours, câblé sur le moteur pur `carre_magic_logic`.
///
/// Portée par partie (pas `keepAlive`) : quand l'écran de jeu qui l'observe
/// est démonté, la partie en cours est abandonnée — pas de persistance ici,
/// c'est un choix pour une future couche data (local ou Supabase Realtime
/// pour le multijoueur), hors périmètre de ce câblage.
final class GameNotifierProvider
    extends $NotifierProvider<GameNotifier, GameState> {
  /// État d'une partie en cours, câblé sur le moteur pur `carre_magic_logic`.
  ///
  /// Portée par partie (pas `keepAlive`) : quand l'écran de jeu qui l'observe
  /// est démonté, la partie en cours est abandonnée — pas de persistance ici,
  /// c'est un choix pour une future couche data (local ou Supabase Realtime
  /// pour le multijoueur), hors périmètre de ce câblage.
  GameNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameNotifierHash();

  @$internal
  @override
  GameNotifier create() => GameNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameState>(value),
    );
  }
}

String _$gameNotifierHash() => r'1d765e094c9329f19102c7168131f3e7e47326b5';

/// État d'une partie en cours, câblé sur le moteur pur `carre_magic_logic`.
///
/// Portée par partie (pas `keepAlive`) : quand l'écran de jeu qui l'observe
/// est démonté, la partie en cours est abandonnée — pas de persistance ici,
/// c'est un choix pour une future couche data (local ou Supabase Realtime
/// pour le multijoueur), hors périmètre de ce câblage.

abstract class _$GameNotifier extends $Notifier<GameState> {
  GameState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GameState, GameState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameState, GameState>,
              GameState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
