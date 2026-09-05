import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_online_match_repository.dart";

/// Abandonne une partie en ligne active — l'adversaire gagne immédiatement.
class ResignMatch {
  const ResignMatch(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, void>> call(String matchId) {
    return _repository.resignMatch(matchId);
  }
}
