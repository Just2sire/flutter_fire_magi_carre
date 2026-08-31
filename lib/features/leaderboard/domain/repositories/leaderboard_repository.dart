import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/leaderboard_entry.dart";

abstract class LeaderboardRepository {
  /// Récupère une page du classement global, triée par
  /// [LeaderboardEntry.rating] décroissant.
  Future<Either<Failure, List<LeaderboardEntry>>> fetchTopPlayers({
    int limit = 50,
    int offset = 0,
  });

  /// Récupère le rang de l'utilisateur courant dans le classement global.
  Future<Either<Failure, LeaderboardEntry>> fetchMyRank();
}
