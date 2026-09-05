import "package:carre_magic_logic/carre_magic_logic.dart";

import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/online_match.dart";

/// Contrat pour lire et muter les parties en ligne — toutes les mutations
/// passent par des RPC Postgres `SECURITY DEFINER` côté serveur.
abstract interface class IOnlineMatchRepository {
  Future<Either<Failure, String?>> queueJoin({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
  });

  Future<Either<Failure, void>> queueLeave();

  Future<Either<Failure, String>> createInviteMatch({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
    required bool rated,
  });

  Future<Either<Failure, String>> joinInviteMatch(String inviteCode);

  Future<Either<Failure, OnlineMatch>> getMatchByInviteCode(
    String inviteCode,
  );

  Future<Either<Failure, void>> initializeMatchState({
    required String matchId,
    required GameState gameState,
  });

  Future<Either<Failure, void>> submitMove({
    required String matchId,
    required GameState newGameState,
    required PlayerColor nextPlayer,
    required GameStatus newStatus,
  });

  Future<Either<Failure, void>> resignMatch(String matchId);

  Future<Either<Failure, void>> claimTimeout(String matchId);

  Future<Either<Failure, void>> markMatchRecorded(String matchId);

  Stream<OnlineMatch> watchMatch(String matchId);

  Stream<List<OnlineMatch>> watchMyActiveMatches(String playerId);

  Stream<String> watchAssignedMatch(String playerId);
}
