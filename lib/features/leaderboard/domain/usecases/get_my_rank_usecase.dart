import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/leaderboard_entry.dart";
import "../repositories/leaderboard_repository.dart";

/// Récupère le rang de l'utilisateur courant via [LeaderboardRepository].
class GetMyRankUseCase {
  const GetMyRankUseCase(this._repository);

  final LeaderboardRepository _repository;

  Future<Either<Failure, LeaderboardEntry>> call() => _repository.fetchMyRank();
}
