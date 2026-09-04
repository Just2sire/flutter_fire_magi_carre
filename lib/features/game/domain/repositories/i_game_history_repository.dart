import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";

/// Contract for recording completed games to the backend.
abstract interface class IGameHistoryRepository {
  Future<Either<Failure, void>> recordGameResult({
    required String playerId,
    required String opponentType,
    required String result,
    required int boardSize,
    required int moveCount,
    required int durationSeconds,
  });
}
