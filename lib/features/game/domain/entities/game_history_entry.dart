/// Represents a completed game recorded in the player's history.
class GameHistoryEntry {
  const GameHistoryEntry({
    required this.id,
    required this.playerId,
    required this.opponentType,
    required this.result,
    required this.boardSize,
    required this.moveCount,
    required this.durationSeconds,
    required this.playerRatingBefore,
    required this.playerRatingAfter,
    required this.ratingDelta,
    required this.createdAt,
  });

  final String id;
  final String playerId;

  /// One of: 'ai_easy', 'ai_medium', 'ai_hard', 'human'.
  final String opponentType;

  /// One of: 'win', 'loss', 'draw'.
  final String result;

  final int boardSize;
  final int moveCount;
  final int durationSeconds;
  final int playerRatingBefore;
  final int playerRatingAfter;

  /// Positive = gained, negative = lost.
  final int ratingDelta;

  final DateTime createdAt;
}
