import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/game_history_entry.dart";
import "../repositories/i_game_history_repository.dart";

/// Récupère l'historique de parties d'un joueur depuis le backend.
class GetGameHistory {
  const GetGameHistory(this._repository);

  final IGameHistoryRepository _repository;

  Future<Either<Failure, List<GameHistoryEntry>>> call({
    required String playerId,
    int limit = 30,
    int offset = 0,
  }) {
    return _repository.getGameHistory(
      playerId: playerId,
      limit: limit,
      offset: offset,
    );
  }
}
