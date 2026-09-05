// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matchmaking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gère la file d'attente de matchmaking — rejoindre, attendre un
/// appariement, annuler. Scope écran (autoDispose) : quitter l'écran
/// d'attente annule la recherche.

@ProviderFor(MatchmakingQueueNotifier)
final matchmakingQueueProvider = MatchmakingQueueNotifierProvider._();

/// Gère la file d'attente de matchmaking — rejoindre, attendre un
/// appariement, annuler. Scope écran (autoDispose) : quitter l'écran
/// d'attente annule la recherche.
final class MatchmakingQueueNotifierProvider
    extends $NotifierProvider<MatchmakingQueueNotifier, MatchmakingState> {
  /// Gère la file d'attente de matchmaking — rejoindre, attendre un
  /// appariement, annuler. Scope écran (autoDispose) : quitter l'écran
  /// d'attente annule la recherche.
  MatchmakingQueueNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'matchmakingQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$matchmakingQueueNotifierHash();

  @$internal
  @override
  MatchmakingQueueNotifier create() => MatchmakingQueueNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MatchmakingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MatchmakingState>(value),
    );
  }
}

String _$matchmakingQueueNotifierHash() =>
    r'0584853a938f206fc52981f1f7fe9e006884e988';

/// Gère la file d'attente de matchmaking — rejoindre, attendre un
/// appariement, annuler. Scope écran (autoDispose) : quitter l'écran
/// d'attente annule la recherche.

abstract class _$MatchmakingQueueNotifier extends $Notifier<MatchmakingState> {
  MatchmakingState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MatchmakingState, MatchmakingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MatchmakingState, MatchmakingState>,
              MatchmakingState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
