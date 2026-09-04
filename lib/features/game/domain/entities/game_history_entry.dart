/// Represents a completed game recorded in the player's history.
class GameHistoryEntry {
  const GameHistoryEntry({
    required this.id,
    required this.playerId,
    required this.opponentType,
    required this.result,
    required this.boardSize,
    required this.moveCount,
    required this.playerRatingBefore,
    required this.playerRatingAfter,
    required this.ratingDelta,
    required this.playedAt,
    this.aiDifficulty,
  });

  final String id;
  final String playerId;

  /// One of: 'ai', 'local_2p', 'online'.
  final String opponentType;

  /// One of: 'easy', 'medium', 'hard'. Null for non-AI games.
  final String? aiDifficulty;

  /// One of: 'win', 'loss', 'draw'.
  final String result;

  final int boardSize;
  final int moveCount;
  final int playerRatingBefore;
  final int playerRatingAfter;

  /// Positive = gained, negative = lost.
  final int ratingDelta;

  final DateTime playedAt;
}
