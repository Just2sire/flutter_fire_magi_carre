import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_online_match_repository.dart";

/// Rejoint la file de matchmaking. Retourne l'id du match si apparié
/// immédiatement, sinon `null` (l'appelant reste en file).
class JoinQueue {
  const JoinQueue(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, String?>> call({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
  }) {
    return _repository.queueJoin(
      timerBaseSeconds: timerBaseSeconds,
      timerIncrementSeconds: timerIncrementSeconds,
    );
  }
}
