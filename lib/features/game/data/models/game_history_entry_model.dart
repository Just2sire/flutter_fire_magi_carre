import "../../domain/entities/game_history_entry.dart";

/// Modèle de données JSON → entité [GameHistoryEntry], utilisé pour mapper
/// les lignes de la table Supabase `game_history`.
class GameHistoryEntryModel extends GameHistoryEntry {
  const GameHistoryEntryModel({
    required super.id,
    required super.playerId,
    required super.opponentType,
    required super.result,
    required super.boardSize,
    required super.moveCount,
    required super.playerRatingBefore,
    required super.playerRatingAfter,
    required super.ratingDelta,
    required super.playedAt,
    super.aiDifficulty,
  });

  factory GameHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    return GameHistoryEntryModel(
      id: json["id"] as String,
      playerId: json["player_id"] as String,
      opponentType: json["opponent_type"] as String,
      aiDifficulty: json["ai_difficulty"] as String?,
      result: json["result"] as String,
      boardSize: json["board_size"] as int,
      moveCount: json["move_count"] as int,
      playerRatingBefore: json["player_rating_before"] as int,
      playerRatingAfter: json["player_rating_after"] as int,
      ratingDelta: json["rating_delta"] as int,
      playedAt: DateTime.parse(json["played_at"] as String),
    );
  }
}
