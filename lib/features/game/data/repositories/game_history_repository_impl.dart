import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../../../../shared/domain/failures/server_failure.dart";
import "../../domain/repositories/i_game_history_repository.dart";
import "../datasources/game_history_remote_datasource.dart";

/// Supabase-backed implementation of [IGameHistoryRepository].
class GameHistoryRepositoryImpl implements IGameHistoryRepository {
  const GameHistoryRepositoryImpl({required this._dataSource});

  final GameHistoryRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, void>> recordGameResult({
    required String playerId,
    required String opponentType,
    required String result,
    required int boardSize,
    required int moveCount,
    required int durationSeconds,
  }) async {
    try {
      await _dataSource.recordGameResult(
        playerId: playerId,
        opponentType: opponentType,
        result: result,
        boardSize: boardSize,
        moveCount: moveCount,
        durationSeconds: durationSeconds,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
