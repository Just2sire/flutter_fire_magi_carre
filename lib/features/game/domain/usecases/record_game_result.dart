import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_game_history_repository.dart";

/// Records a completed game to the backend and updates the player's ELO.
class RecordGameResult {
  const RecordGameResult(this._repository);

  final IGameHistoryRepository _repository;

  Future<Either<Failure, void>> call({
    required String playerId,
    required String opponentType,
    required String result,
    required int boardSize,
    required int moveCount,
    String? aiDifficulty,
  }) {
    return _repository.recordGameResult(
      playerId: playerId,
      opponentType: opponentType,
      result: result,
      boardSize: boardSize,
      moveCount: moveCount,
      aiDifficulty: aiDifficulty,
    );
  }
}
