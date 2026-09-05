import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "online_match_providers.dart";

part "matchmaking_providers.g.dart";

/// Étape de la recherche d'une partie rapide.
enum MatchmakingStatus { idle, searching, matched, error }

/// État exposé par [MatchmakingQueueNotifier].
class MatchmakingState {
  const MatchmakingState({
    required this.status,
    this.matchId,
    this.errorMessage,
  });

  final MatchmakingStatus status;
  final String? matchId;
  final String? errorMessage;
}

/// Gère la file d'attente de matchmaking — rejoindre, attendre un
/// appariement, annuler. Scope écran (autoDispose) : quitter l'écran
/// d'attente annule la recherche.
@riverpod
class MatchmakingQueueNotifier extends _$MatchmakingQueueNotifier {
  StreamSubscription<String>? _assignedSubscription;

  @override
  MatchmakingState build() {
    ref.onDispose(() => _assignedSubscription?.cancel());
    return const MatchmakingState(status: MatchmakingStatus.idle);
  }

  Future<void> join({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
  }) async {
    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;
    final myId = authState.profile.id;

    state = const MatchmakingState(status: MatchmakingStatus.searching);

    final result = await ref
        .read(joinQueueUseCaseProvider)
        .call(
          timerBaseSeconds: timerBaseSeconds,
          timerIncrementSeconds: timerIncrementSeconds,
        );

    result.fold(
      (failure) {
        state = MatchmakingState(
          status: MatchmakingStatus.error,
          errorMessage: failure.message,
        );
      },
      (matchId) {
        if (matchId != null) {
          state = MatchmakingState(
            status: MatchmakingStatus.matched,
            matchId: matchId,
          );
          return;
        }
        _assignedSubscription = ref
            .read(watchAssignedMatchUseCaseProvider)
            .call(myId)
            .listen((assignedMatchId) {
              state = MatchmakingState(
                status: MatchmakingStatus.matched,
                matchId: assignedMatchId,
              );
            });
      },
    );
  }

  Future<void> cancel() async {
    await _assignedSubscription?.cancel();
    _assignedSubscription = null;
    await ref.read(leaveQueueUseCaseProvider).call();
    state = const MatchmakingState(status: MatchmakingStatus.idle);
  }
}
