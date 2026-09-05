import "package:carre_magic_logic/carre_magic_logic.dart";

import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../../../../shared/domain/failures/server_failure.dart";
import "../../domain/entities/online_match.dart";
import "../../domain/repositories/i_online_match_repository.dart";
import "../datasources/online_match_remote_datasource.dart";

/// Implémentation Supabase de [IOnlineMatchRepository].
class OnlineMatchRepositoryImpl implements IOnlineMatchRepository {
  const OnlineMatchRepositoryImpl({required this._dataSource});

  final OnlineMatchRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, String?>> queueJoin({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
  }) async {
    try {
      final matchId = await _dataSource.queueJoin(
        timerBaseSeconds: timerBaseSeconds,
        timerIncrementSeconds: timerIncrementSeconds,
      );
      return Right(matchId);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> queueLeave() async {
    try {
      await _dataSource.queueLeave();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createInviteMatch({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
    required bool rated,
  }) async {
    try {
      final code = await _dataSource.createInviteMatch(
        timerBaseSeconds: timerBaseSeconds,
        timerIncrementSeconds: timerIncrementSeconds,
        rated: rated,
      );
      return Right(code);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> joinInviteMatch(String inviteCode) async {
    try {
      final matchId = await _dataSource.joinInviteMatch(inviteCode);
      return Right(matchId);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OnlineMatch>> getMatchByInviteCode(
    String inviteCode,
  ) async {
    try {
      final match = await _dataSource.getMatchByInviteCode(inviteCode);
      return Right(match);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> initializeMatchState({
    required String matchId,
    required GameState gameState,
  }) async {
    try {
      await _dataSource.initializeMatchState(
        matchId: matchId,
        gameState: gameState,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitMove({
    required String matchId,
    required GameState newGameState,
    required PlayerColor nextPlayer,
    required GameStatus newStatus,
  }) async {
    try {
      await _dataSource.submitMove(
        matchId: matchId,
        newGameState: newGameState,
        nextPlayer: nextPlayer,
        newStatus: newStatus,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resignMatch(String matchId) async {
    try {
      await _dataSource.resignMatch(matchId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> claimTimeout(String matchId) async {
    try {
      await _dataSource.claimTimeout(matchId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markMatchRecorded(String matchId) async {
    try {
      await _dataSource.markMatchRecorded(matchId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<OnlineMatch> watchMatch(String matchId) =>
      _dataSource.watchMatch(matchId);

  @override
  Stream<List<OnlineMatch>> watchMyActiveMatches(String playerId) =>
      _dataSource.watchMyActiveMatches(playerId);

  @override
  Stream<String> watchAssignedMatch(String playerId) =>
      _dataSource.watchAssignedMatch(playerId);
}
