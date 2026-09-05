import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/data/services/local_cache_service.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../../../../shared/domain/failures/network_failure.dart";
import "../../../../shared/domain/failures/server_failure.dart";
import "../../../../shared/domain/network_info.dart";
import "../../domain/entities/game_history_entry.dart";
import "../../domain/repositories/i_game_history_repository.dart";
import "../datasources/game_history_remote_datasource.dart";
import "../models/game_history_entry_model.dart";

/// Supabase-backed implementation of [IGameHistoryRepository] — repli sur un
/// cache local (Hive) pour la lecture quand l'appareil est hors-ligne.
class GameHistoryRepositoryImpl implements IGameHistoryRepository {
  const GameHistoryRepositoryImpl({
    required GameHistoryRemoteDataSource dataSource,
    required LocalCacheService cache,
    required NetworkInfo networkInfo,
  }) : _dataSource = dataSource,
       _cache = cache,
       _networkInfo = networkInfo;

  final GameHistoryRemoteDataSource _dataSource;
  final LocalCacheService _cache;
  final NetworkInfo _networkInfo;

  String _cacheKey(String playerId) => "game_history_$playerId";

  @override
  Future<Either<Failure, void>> recordGameResult({
    required String playerId,
    required String opponentType,
    required String result,
    required int boardSize,
    required int moveCount,
    String? aiDifficulty,
    String? opponentId,
    bool rated = true,
  }) async {
    try {
      await _dataSource.recordGameResult(
        playerId: playerId,
        opponentType: opponentType,
        result: result,
        boardSize: boardSize,
        moveCount: moveCount,
        aiDifficulty: aiDifficulty,
        opponentId: opponentId,
        rated: rated,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GameHistoryEntry>>> getGameHistory({
    required String playerId,
    int limit = 30,
    int offset = 0,
  }) async {
    if (!await _networkInfo.isConnected) {
      return _readCache(playerId);
    }

    try {
      final entries = await _dataSource.getGameHistory(
        playerId: playerId,
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        await _cache.saveList(_cacheKey(playerId), [
          for (final entry in entries)
            (entry as GameHistoryEntryModel).toCacheJson(),
        ]);
      }
      return Right(entries);
    } on Exception catch (e) {
      final cached = _readCache(playerId);
      if (cached is Right<Failure, List<GameHistoryEntry>>) return cached;
      return Left(ServerFailure(message: e.toString(), cause: e));
    }
  }

  Either<Failure, List<GameHistoryEntry>> _readCache(String playerId) {
    final cached = _cache.readList(_cacheKey(playerId));
    if (cached == null) {
      return const Left(
        NetworkFailure(message: "Pas de connexion et aucune donnée en cache."),
      );
    }
    return Right([
      for (final json in cached.items)
        GameHistoryEntryModel.fromCachedJson(json),
    ]);
  }
}
