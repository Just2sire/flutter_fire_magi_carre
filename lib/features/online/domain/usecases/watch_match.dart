import "../entities/online_match.dart";
import "../repositories/i_online_match_repository.dart";

/// Émet l'état courant d'une partie puis chaque mise à jour distante.
class WatchMatch {
  const WatchMatch(this._repository);

  final IOnlineMatchRepository _repository;

  Stream<OnlineMatch> call(String matchId) => _repository.watchMatch(matchId);
}
