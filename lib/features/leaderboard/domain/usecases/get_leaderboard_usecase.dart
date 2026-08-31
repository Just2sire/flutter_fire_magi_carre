import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/leaderboard_entry.dart";
import "../repositories/leaderboard_repository.dart";

/// Récupère une page du classement global via [LeaderboardRepository].
class GetLeaderboardUseCase {
  const GetLeaderboardUseCase(this._repository);

  final LeaderboardRepository _repository;

  Future<Either<Failure, List<LeaderboardEntry>>> call({
    int limit = 50,
    int offset = 0,
  }) => _repository.fetchTopPlayers(limit: limit, offset: offset);
}
