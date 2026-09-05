import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/data/services/local_cache_service.dart";
import "../../../../shared/domain/failures/index.dart";
import "../../../../shared/domain/network_info.dart";
import "../../domain/entities/leaderboard_entry.dart";
import "../../domain/repositories/leaderboard_repository.dart";
import "../datasources/leaderboard_remote_datasource.dart";
import "../models/leaderboard_entry_model.dart";

/// Implémentation [LeaderboardRepository] — source réseau (REST via
/// [LeaderboardRemoteDataSource]) avec repli sur un cache local (Hive)
/// quand l'appareil est hors-ligne, ou que le réseau échoue malgré une
/// connectivité apparente.
class LeaderboardRepositoryImpl implements LeaderboardRepository {
  const LeaderboardRepositoryImpl({
    required this._remoteDataSource,
    required this._cache,
    required this._networkInfo,
  });

  final LeaderboardRemoteDataSource _remoteDataSource;
  final LocalCacheService _cache;
  final NetworkInfo _networkInfo;

  static const _topPlayersCacheKey = "leaderboard_top_players";
  static const _myRankCacheKey = "leaderboard_my_rank";

  @override
  Future<Either<Failure, List<LeaderboardEntry>>> fetchTopPlayers({
    int limit = 50,
    int offset = 0,
  }) async {
    if (!await _networkInfo.isConnected) {
      return _readTopPlayersCache();
    }

    try {
      final entries = await _remoteDataSource.fetchTopPlayers(
        limit: limit,
        offset: offset,
      );
      // Seule la première page est mise en cache — représentative pour le
      // repli hors-ligne, pas besoin de dupliquer chaque page consultée.
      if (offset == 0) {
        await _cache.saveList(_topPlayersCacheKey, [
          for (final entry in entries) entry.toCacheJson(),
        ]);
      }
      return Right(entries);
    } on Exception catch (e) {
      final cached = _readTopPlayersCache();
      if (cached is Right<Failure, List<LeaderboardEntry>>) return cached;
      return Left(ServerFailure(message: e.toString(), cause: e));
    }
  }

  Either<Failure, List<LeaderboardEntry>> _readTopPlayersCache() {
    final cached = _cache.readList(_topPlayersCacheKey);
    if (cached == null) {
      return const Left(
        NetworkFailure(message: "Pas de connexion et aucune donnée en cache."),
      );
    }
    return Right([
      for (final json in cached.items)
        LeaderboardEntryModel.fromCachedJson(json),
    ]);
  }

  @override
  Future<Either<Failure, LeaderboardEntry>> fetchMyRank() async {
    if (!await _networkInfo.isConnected) {
      return _readMyRankCache();
    }

    try {
      final userId = _remoteDataSource.getCurrentUserId();
      if (userId == null) return const Left(UserNotFoundFailure());

      final entry = await _remoteDataSource.fetchMyRank(userId: userId);
      await _cache.saveObject(_myRankCacheKey, entry.toCacheJson());
      return Right(entry);
    } on Exception catch (e) {
      final cached = _readMyRankCache();
      if (cached is Right<Failure, LeaderboardEntry>) return cached;
      return Left(ServerFailure(message: e.toString(), cause: e));
    }
  }

  Either<Failure, LeaderboardEntry> _readMyRankCache() {
    final cached = _cache.readObject(_myRankCacheKey);
    if (cached == null) {
      return const Left(
        NetworkFailure(message: "Pas de connexion et aucune donnée en cache."),
      );
    }
    return Right(LeaderboardEntryModel.fromCachedJson(cached.item));
  }
}
