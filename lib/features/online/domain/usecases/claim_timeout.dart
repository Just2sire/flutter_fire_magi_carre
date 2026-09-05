import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_online_match_repository.dart";

/// Réclame la victoire au temps si la pendule du joueur dont c'est le tour
/// est épuisée (recalculée côté serveur) — no-op sinon.
class ClaimTimeout {
  const ClaimTimeout(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, void>> call(String matchId) {
    return _repository.claimTimeout(matchId);
  }
}
