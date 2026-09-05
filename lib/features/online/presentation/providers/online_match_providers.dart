import "dart:async";

import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/supabase_provider.dart";
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "../../../game/presentation/providers/game_history_providers.dart";
import "../../data/datasources/online_match_remote_datasource.dart";
import "../../data/repositories/online_match_repository_impl.dart";
import "../../domain/entities/online_match.dart";
import "../../domain/repositories/i_online_match_repository.dart";
import "../../domain/usecases/claim_timeout.dart";
import "../../domain/usecases/create_invite_match.dart";
import "../../domain/usecases/get_match_by_invite_code.dart";
import "../../domain/usecases/initialize_match_state.dart";
import "../../domain/usecases/join_invite_match.dart";
import "../../domain/usecases/join_queue.dart";
import "../../domain/usecases/leave_queue.dart";
import "../../domain/usecases/mark_match_recorded.dart";
import "../../domain/usecases/resign_match.dart";
import "../../domain/usecases/submit_move.dart";
import "../../domain/usecases/watch_assigned_match.dart";
import "../../domain/usecases/watch_match.dart";
import "../../domain/usecases/watch_my_active_matches.dart";

part "online_match_providers.g.dart";

// ─── Infrastructure ─────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
OnlineMatchRemoteDataSourceImpl onlineMatchRemoteDataSource(Ref ref) {
  return OnlineMatchRemoteDataSourceImpl(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
}

@Riverpod(keepAlive: true)
IOnlineMatchRepository onlineMatchRepository(Ref ref) {
  return OnlineMatchRepositoryImpl(
    dataSource: ref.watch(onlineMatchRemoteDataSourceProvider),
  );
}

// ─── Use cases ──────────────────────────────────────────────────────────

@riverpod
JoinQueue joinQueueUseCase(Ref ref) =>
    JoinQueue(ref.watch(onlineMatchRepositoryProvider));

@riverpod
LeaveQueue leaveQueueUseCase(Ref ref) =>
    LeaveQueue(ref.watch(onlineMatchRepositoryProvider));

@riverpod
CreateInviteMatch createInviteMatchUseCase(Ref ref) =>
    CreateInviteMatch(ref.watch(onlineMatchRepositoryProvider));

@riverpod
JoinInviteMatch joinInviteMatchUseCase(Ref ref) =>
    JoinInviteMatch(ref.watch(onlineMatchRepositoryProvider));

@riverpod
GetMatchByInviteCode getMatchByInviteCodeUseCase(Ref ref) =>
    GetMatchByInviteCode(ref.watch(onlineMatchRepositoryProvider));

@riverpod
InitializeMatchState initializeMatchStateUseCase(Ref ref) =>
    InitializeMatchState(ref.watch(onlineMatchRepositoryProvider));

@riverpod
SubmitMove submitMoveUseCase(Ref ref) =>
    SubmitMove(ref.watch(onlineMatchRepositoryProvider));

@riverpod
ResignMatch resignMatchUseCase(Ref ref) =>
    ResignMatch(ref.watch(onlineMatchRepositoryProvider));

@riverpod
ClaimTimeout claimTimeoutUseCase(Ref ref) =>
    ClaimTimeout(ref.watch(onlineMatchRepositoryProvider));

@riverpod
MarkMatchRecorded markMatchRecordedUseCase(Ref ref) =>
    MarkMatchRecorded(ref.watch(onlineMatchRepositoryProvider));

@riverpod
WatchMatch watchMatchUseCase(Ref ref) =>
    WatchMatch(ref.watch(onlineMatchRepositoryProvider));

@riverpod
WatchMyActiveMatches watchMyActiveMatchesUseCase(Ref ref) =>
    WatchMyActiveMatches(ref.watch(onlineMatchRepositoryProvider));

@riverpod
WatchAssignedMatch watchAssignedMatchUseCase(Ref ref) =>
    WatchAssignedMatch(ref.watch(onlineMatchRepositoryProvider));

// ─── Liste des parties à reprendre ──────────────────────────────────────

@riverpod
Stream<List<OnlineMatch>> myActiveMatches(Ref ref) {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return const Stream.empty();
  return ref
      .watch(watchMyActiveMatchesUseCaseProvider)
      .call(authState.profile.id);
}

// ─── État exposé par OnlineMatchNotifier ────────────────────────────────

/// État d'une partie en ligne tel qu'exposé à l'écran de jeu — combine
/// l'entité synchronisée avec Supabase et les pendules décomptées
/// localement entre deux mises à jour serveur.
class OnlineMatchState {
  const OnlineMatchState({
    required this.match,
    required this.myColor,
    required this.whiteTimeLeftMs,
    required this.blackTimeLeftMs,
  });

  final OnlineMatch match;
  final PlayerColor? myColor;
  final int? whiteTimeLeftMs;
  final int? blackTimeLeftMs;

  bool get isMyTurn => myColor != null && myColor == match.currentPlayer;
}

// ─── Notifier de partie en ligne ────────────────────────────────────────

/// Remplace GameNotifier (mode local) pour une partie en ligne : la
/// vérité de l'état de jeu vit dans Supabase, ce notifier s'y synchronise
/// via Realtime, applique les coups localement avec les mêmes fonctions
/// pures du moteur avant de les soumettre, et fait tourner les deux
/// pendules à l'affichage entre deux syncs serveur.
@riverpod
class OnlineMatchNotifier extends _$OnlineMatchNotifier {
  StreamSubscription<OnlineMatch>? _subscription;
  Timer? _clockTimer;
  bool _recordingInFlight = false;

  String get _myId => (ref.read(authProvider) as AuthAuthenticated).profile.id;

  @override
  Future<OnlineMatchState> build(String matchId) async {
    ref.onDispose(() {
      _subscription?.cancel();
      _clockTimer?.cancel();
    });

    final stream = ref.watch(watchMatchUseCaseProvider).call(matchId);
    final completer = Completer<OnlineMatchState>();

    _subscription = stream.listen(
      (match) {
        final next = _buildState(match);
        if (!completer.isCompleted) {
          completer.complete(next);
        } else {
          state = AsyncData(next);
          unawaited(_handlePostUpdate(match));
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        } else {
          state = AsyncError(error, stackTrace);
        }
      },
    );

    final first = await completer.future;
    unawaited(_handlePostUpdate(first.match));
    return first;
  }

  OnlineMatchState _buildState(OnlineMatch match) {
    return OnlineMatchState(
      match: match,
      myColor: match.colorFor(_myId),
      whiteTimeLeftMs: match.whiteTimeRemainingMs,
      blackTimeLeftMs: match.blackTimeRemainingMs,
    );
  }

  /// Joue [move] localement (comme en mode local) puis soumet le nouvel
  /// état — no-op si ce n'est pas mon tour ou que la partie n'est pas
  /// active.
  Future<void> playMove(Move move) async {
    final current = state.value;
    if (current == null || !current.isMyTurn) return;
    final before = current.match.gameState;
    if (before == null) return;

    final after = ApplyMove.call(before, move);
    await ref
        .read(submitMoveUseCaseProvider)
        .call(
          matchId: matchId,
          newGameState: after,
          nextPlayer: after.currentPlayer,
          newStatus: after.status,
        );
  }

  /// Résout une promotion en attente en choisissant [slot].
  Future<void> resolvePromotion(Position slot) async {
    final current = state.value;
    if (current == null) return;
    final before = current.match.gameState;
    if (before == null) return;

    final result = ApplyPromotion.call(before, slot);
    if (result is! Ok<GameState>) return;
    final after = result.value;

    await ref
        .read(submitMoveUseCaseProvider)
        .call(
          matchId: matchId,
          newGameState: after,
          nextPlayer: after.currentPlayer,
          newStatus: after.status,
        );
  }

  /// Coups légaux pour le pion à [pos], calculés localement — pur, pas
  /// besoin d'aller-retour serveur.
  List<Move> validMovesFor(Position pos) {
    final gameState = state.value?.match.gameState;
    if (gameState == null) return const [];
    return GetValidMoves.forState(gameState, pos);
  }

  /// Abandonne la partie — l'adversaire gagne immédiatement.
  Future<void> resign() => ref.read(resignMatchUseCaseProvider).call(matchId);

  void _restartClock(OnlineMatch match) {
    _clockTimer?.cancel();
    if (match.status != MatchStatus.active) return;
    if (match.whiteTimeRemainingMs == null &&
        match.blackTimeRemainingMs == null) {
      return;
    }
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _onClockTick(),
    );
  }

  void _onClockTick() {
    final current = state.value;
    if (current == null) return;
    final match = current.match;
    if (match.status != MatchStatus.active || match.turnStartedAt == null) {
      _clockTimer?.cancel();
      return;
    }

    final elapsedMs = DateTime.now()
        .difference(match.turnStartedAt!)
        .inMilliseconds;
    var whiteLeft = match.whiteTimeRemainingMs;
    var blackLeft = match.blackTimeRemainingMs;

    if (match.currentPlayer == PlayerColor.white && whiteLeft != null) {
      whiteLeft = whiteLeft - elapsedMs < 0 ? 0 : whiteLeft - elapsedMs;
    } else if (match.currentPlayer == PlayerColor.black && blackLeft != null) {
      blackLeft = blackLeft - elapsedMs < 0 ? 0 : blackLeft - elapsedMs;
    }

    state = AsyncData(
      OnlineMatchState(
        match: match,
        myColor: current.myColor,
        whiteTimeLeftMs: whiteLeft,
        blackTimeLeftMs: blackLeft,
      ),
    );

    final movingPlayerLeft = match.currentPlayer == PlayerColor.white
        ? whiteLeft
        : blackLeft;
    if (movingPlayerLeft != null && movingPlayerLeft <= 0) {
      _clockTimer?.cancel();
      unawaited(ref.read(claimTimeoutUseCaseProvider).call(matchId));
    }
  }

  /// Redémarre la pendule locale sur la nouvelle vérité serveur, initialise
  /// le plateau si la partie vient de s'activer, et enregistre le résultat
  /// (ELO + historique) une fois la partie terminée si ce n'est pas déjà
  /// fait pour ma couleur.
  Future<void> _handlePostUpdate(OnlineMatch match) async {
    _restartClock(match);

    if (match.status == MatchStatus.active && match.gameState == null) {
      await ref
          .read(initializeMatchStateUseCaseProvider)
          .call(matchId: matchId, gameState: InitializeGame.call());
      return;
    }

    if (match.status != MatchStatus.finished || _recordingInFlight) return;

    final myColor = match.colorFor(_myId);
    if (myColor == null) return;
    final alreadyRecorded = myColor == PlayerColor.white
        ? match.whiteRecorded
        : match.blackRecorded;
    if (alreadyRecorded) return;

    _recordingInFlight = true;
    try {
      await ref
          .read(recordGameResultUseCaseProvider)
          .call(
            playerId: _myId,
            opponentType: "online",
            opponentId: match.opponentIdFor(_myId),
            result: _myResultString(match, myColor),
            boardSize: match.gameState?.board.size ?? 5,
            moveCount: match.gameState?.moveHistory.length ?? 0,
            rated: match.rated,
          );
      await ref.read(markMatchRecordedUseCaseProvider).call(matchId);
    } finally {
      _recordingInFlight = false;
    }
  }

  String _myResultString(OnlineMatch match, PlayerColor myColor) {
    return switch (match.result) {
      MatchResult.draw => "draw",
      MatchResult.whiteWins =>
        myColor == PlayerColor.white ? "win" : "loss",
      MatchResult.blackWins =>
        myColor == PlayerColor.black ? "win" : "loss",
      null => "loss",
    };
  }
}
