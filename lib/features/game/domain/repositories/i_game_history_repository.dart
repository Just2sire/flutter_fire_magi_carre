import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/game_history_entry.dart";

/// Contract for reading and writing game history to the backend.
abstract interface class IGameHistoryRepository {
  Future<Either<Failure, void>> recordGameResult({
    required String playerId,
    required String opponentType,
    required String result,
    required int boardSize,
    required int moveCount,
    String? aiDifficulty,
  });

  Future<Either<Failure, List<GameHistoryEntry>>> getGameHistory({
    required String playerId,
    int limit = 30,
    int offset = 0,
  });
}
