import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_online_match_repository.dart";

/// Marque le résultat de la partie comme déjà enregistré (ELO/historique)
/// pour l'appelant — garde d'idempotence après un appel réussi à
/// `record_game_result`.
class MarkMatchRecorded {
  const MarkMatchRecorded(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, void>> call(String matchId) {
    return _repository.markMatchRecorded(matchId);
  }
}
