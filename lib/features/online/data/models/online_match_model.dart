import "package:carre_magic_logic/carre_magic_logic.dart";

import "../../domain/entities/online_match.dart";

/// Modèle de données JSON → entité [OnlineMatch], mappe les lignes de la
/// table Supabase `matches`. `game_state` est décodé via le codec JSON du
/// moteur (`GameStateJson`).
class OnlineMatchModel extends OnlineMatch {
  const OnlineMatchModel({
    required super.id,
    required super.status,
    required super.rated,
    required super.creatorId,
    required super.timerBaseSeconds,
    required super.timerIncrementSeconds,
    required super.whiteRecorded,
    required super.blackRecorded,
    super.inviteCode,
    super.whitePlayerId,
    super.blackPlayerId,
    super.gameState,
    super.currentPlayer,
    super.whiteTimeRemainingMs,
    super.blackTimeRemainingMs,
    super.turnStartedAt,
    super.result,
    super.endReason,
  });

  factory OnlineMatchModel.fromJson(Map<String, dynamic> json) {
    return OnlineMatchModel(
      id: json["id"] as String,
      status: MatchStatus.values.byName(json["status"] as String),
      rated: json["rated"] as bool,
      creatorId: json["creator_id"] as String,
      timerBaseSeconds: json["timer_base_seconds"] as int,
      timerIncrementSeconds: json["timer_increment_seconds"] as int,
      whiteRecorded: json["white_recorded"] as bool,
      blackRecorded: json["black_recorded"] as bool,
      inviteCode: json["invite_code"] as String?,
      whitePlayerId: json["white_player_id"] as String?,
      blackPlayerId: json["black_player_id"] as String?,
      gameState: json["game_state"] == null
          ? null
          : GameStateJson.fromJson(json["game_state"] as Map<String, dynamic>),
      currentPlayer: json["current_player"] == null
          ? null
          : PlayerColor.values.byName(json["current_player"] as String),
      whiteTimeRemainingMs: json["white_time_remaining_ms"] as int?,
      blackTimeRemainingMs: json["black_time_remaining_ms"] as int?,
      turnStartedAt: json["turn_started_at"] == null
          ? null
          : DateTime.parse(json["turn_started_at"] as String),
      result: json["result"] == null
          ? null
          : _resultFromDb(json["result"] as String),
      endReason: json["end_reason"] == null
          ? null
          : MatchEndReason.values.byName(json["end_reason"] as String),
    );
  }

  static MatchResult _resultFromDb(String value) => switch (value) {
    "white_wins" => MatchResult.whiteWins,
    "black_wins" => MatchResult.blackWins,
    _ => MatchResult.draw,
  };
}
