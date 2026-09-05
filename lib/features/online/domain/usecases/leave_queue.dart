import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_online_match_repository.dart";

/// Annule l'entrée de l'appelant dans la file de matchmaking.
class LeaveQueue {
  const LeaveQueue(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, void>> call() => _repository.queueLeave();
}
