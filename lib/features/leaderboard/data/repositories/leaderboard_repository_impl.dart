import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/index.dart";
import "../../domain/entities/leaderboard_entry.dart";
import "../../domain/repositories/leaderboard_repository.dart";
import "../datasources/leaderboard_remote_datasource.dart";

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  const LeaderboardRepositoryImpl({required this._remoteDataSource});

  final LeaderboardRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<LeaderboardEntry>>> fetchTopPlayers({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final entries = await _remoteDataSource.fetchTopPlayers(
        limit: limit,
        offset: offset,
      );
      return Right(entries);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeaderboardEntry>> fetchMyRank() async {
    try {
      final userId = _remoteDataSource.getCurrentUserId();
      if (userId == null) return const Left(UserNotFoundFailure());

      final entry = await _remoteDataSource.fetchMyRank(userId: userId);
      return Right(entry);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
