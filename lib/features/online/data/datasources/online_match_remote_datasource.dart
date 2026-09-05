import "dart:async";

import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:supabase_flutter/supabase_flutter.dart" as sb;

import "../models/online_match_model.dart";

/// Contrat de la datasource distante pour les parties en ligne — appels RPC
/// pour toutes les mutations, souscriptions Realtime pour la lecture live.
abstract interface class OnlineMatchRemoteDataSource {
  /// Rejoint la file d'attente. Retourne l'id du match si un adversaire
  /// compatible était déjà en attente (appariement immédiat), sinon `null`
  /// (l'appelant reste en file).
  Future<String?> queueJoin({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
  });

  Future<void> queueLeave();

  /// Crée une partie en attente d'invitation, retourne le code à partager.
  Future<String> createInviteMatch({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
    required bool rated,
  });

  /// Rejoint une partie par son code, retourne l'id du match.
  Future<String> joinInviteMatch(String inviteCode);

  Future<OnlineMatchModel> getMatch(String matchId);

  /// Initialise `game_state` sur une partie tout juste activée — no-op côté
  /// serveur si un autre client l'a déjà fait (garde atomique
  /// `WHERE game_state IS NULL`).
  Future<void> initializeMatchState({
    required String matchId,
    required GameState gameState,
  });

  /// Retrouve une partie en attente par son code d'invitation — utilisé par
  /// le créateur pour obtenir l'id de son propre match juste après
  /// `createInviteMatch`.
  Future<OnlineMatchModel> getMatchByInviteCode(String inviteCode);

  Future<void> submitMove({
    required String matchId,
    required GameState newGameState,
    required PlayerColor nextPlayer,
    required GameStatus newStatus,
  });

  Future<void> resignMatch(String matchId);

  Future<void> claimTimeout(String matchId);

  Future<void> markMatchRecorded(String matchId);

  /// Émet l'état courant du match puis chaque mise à jour distante.
  Stream<OnlineMatchModel> watchMatch(String matchId);

  /// Émet la liste des parties actives où [playerId] est participant,
  /// rafraîchie à chaque changement sur la table.
  Stream<List<OnlineMatchModel>> watchMyActiveMatches(String playerId);

  /// Émet l'id du match dès qu'une partie assigne [playerId] comme
  /// participant (appariement par un autre client pendant que celui-ci
  /// attend en file).
  Stream<String> watchAssignedMatch(String playerId);
}

class OnlineMatchRemoteDataSourceImpl implements OnlineMatchRemoteDataSource {
  const OnlineMatchRemoteDataSourceImpl({
    required sb.SupabaseClient supabaseClient,
  }) : _supabase = supabaseClient;

  final sb.SupabaseClient _supabase;

  @override
  Future<String?> queueJoin({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
  }) async {
    final result = await _supabase.rpc<String?>(
      "queue_join",
      params: {
        "p_timer_base": timerBaseSeconds,
        "p_timer_increment": timerIncrementSeconds,
      },
    );
    return result;
  }

  @override
  Future<void> queueLeave() async {
    await _supabase.rpc<void>("queue_leave");
  }

  @override
  Future<String> createInviteMatch({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
    required bool rated,
  }) async {
    final result = await _supabase.rpc<String>(
      "create_invite_match",
      params: {
        "p_timer_base": timerBaseSeconds,
        "p_timer_increment": timerIncrementSeconds,
        "p_rated": rated,
      },
    );
    return result;
  }

  @override
  Future<String> joinInviteMatch(String inviteCode) async {
    final result = await _supabase.rpc<String>(
      "join_invite_match",
      params: {"p_invite_code": inviteCode},
    );
    return result;
  }

  @override
  Future<OnlineMatchModel> getMatch(String matchId) async {
    final row = await _supabase
        .from("matches")
        .select()
        .eq("id", matchId)
        .single();
    return OnlineMatchModel.fromJson(row);
  }

  @override
  Future<OnlineMatchModel> getMatchByInviteCode(String inviteCode) async {
    final row = await _supabase
        .from("matches")
        .select()
        .eq("invite_code", inviteCode)
        .single();
    return OnlineMatchModel.fromJson(row);
  }

  @override
  Future<void> initializeMatchState({
    required String matchId,
    required GameState gameState,
  }) async {
    await _supabase.rpc<void>(
      "initialize_match_state",
      params: {"p_match_id": matchId, "p_game_state": gameState.toJson()},
    );
  }

  @override
  Future<void> submitMove({
    required String matchId,
    required GameState newGameState,
    required PlayerColor nextPlayer,
    required GameStatus newStatus,
  }) async {
    await _supabase.rpc<void>(
      "submit_move",
      params: {
        "p_match_id": matchId,
        "p_new_game_state": newGameState.toJson(),
        "p_next_player": nextPlayer.name,
        "p_new_status": newStatus.name,
      },
    );
  }

  @override
  Future<void> resignMatch(String matchId) async {
    await _supabase.rpc<void>("resign_match", params: {"p_match_id": matchId});
  }

  @override
  Future<void> claimTimeout(String matchId) async {
    await _supabase.rpc<void>(
      "claim_timeout",
      params: {"p_match_id": matchId},
    );
  }

  @override
  Future<void> markMatchRecorded(String matchId) async {
    await _supabase.rpc<void>(
      "mark_match_recorded",
      params: {"p_match_id": matchId},
    );
  }

  @override
  Stream<OnlineMatchModel> watchMatch(String matchId) {
    late final sb.RealtimeChannel channel;
    late final StreamController<OnlineMatchModel> controller;

    Future<void> emitCurrent() async {
      try {
        final model = await getMatch(matchId);
        if (!controller.isClosed) controller.add(model);
      } on Object catch (error, stackTrace) {
        if (!controller.isClosed) controller.addError(error, stackTrace);
      }
    }

    controller = StreamController<OnlineMatchModel>(
      onListen: () {
        emitCurrent();
        channel = _supabase
            .channel("match:$matchId")
            .onPostgresChanges(
              event: sb.PostgresChangeEvent.update,
              schema: "public",
              table: "matches",
              filter: sb.PostgresChangeFilter(
                type: sb.PostgresChangeFilterType.eq,
                column: "id",
                value: matchId,
              ),
              callback: (payload) {
                if (!controller.isClosed) {
                  controller.add(OnlineMatchModel.fromJson(payload.newRecord));
                }
              },
            )
            .subscribe();
      },
      onCancel: () {
        _supabase.removeChannel(channel);
        controller.close();
      },
    );

    return controller.stream;
  }

  @override
  Stream<List<OnlineMatchModel>> watchMyActiveMatches(String playerId) {
    late final sb.RealtimeChannel channel;
    late final StreamController<List<OnlineMatchModel>> controller;

    Future<void> refresh() async {
      try {
        final rows = await _supabase
            .from("matches")
            .select()
            .eq("status", "active")
            .or("white_player_id.eq.$playerId,black_player_id.eq.$playerId");
        if (!controller.isClosed) {
          controller.add([
            for (final row in rows) OnlineMatchModel.fromJson(row),
          ]);
        }
      } on Object catch (error, stackTrace) {
        if (!controller.isClosed) controller.addError(error, stackTrace);
      }
    }

    controller = StreamController<List<OnlineMatchModel>>(
      onListen: () {
        refresh();
        channel = _supabase
            .channel("my-matches:$playerId")
            .onPostgresChanges(
              event: sb.PostgresChangeEvent.all,
              schema: "public",
              table: "matches",
              callback: (_) => refresh(),
            )
            .subscribe();
      },
      onCancel: () {
        _supabase.removeChannel(channel);
        controller.close();
      },
    );

    return controller.stream;
  }

  @override
  Stream<String> watchAssignedMatch(String playerId) {
    late final sb.RealtimeChannel channel;
    late final StreamController<String> controller;

    controller = StreamController<String>(
      onListen: () {
        channel = _supabase
            .channel("assigned-match:$playerId")
            .onPostgresChanges(
              event: sb.PostgresChangeEvent.insert,
              schema: "public",
              table: "matches",
              callback: (payload) {
                final row = payload.newRecord;
                if (row["white_player_id"] == playerId ||
                    row["black_player_id"] == playerId) {
                  if (!controller.isClosed) {
                    controller.add(row["id"] as String);
                  }
                }
              },
            )
            .subscribe();
      },
      onCancel: () {
        _supabase.removeChannel(channel);
        controller.close();
      },
    );

    return controller.stream;
  }
}
