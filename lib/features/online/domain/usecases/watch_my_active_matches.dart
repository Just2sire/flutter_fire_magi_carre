import "../entities/online_match.dart";
import "../repositories/i_online_match_repository.dart";

/// Émet la liste des parties actives où le joueur donné est participant —
/// pour la liste "parties à reprendre" du lobby.
class WatchMyActiveMatches {
  const WatchMyActiveMatches(this._repository);

  final IOnlineMatchRepository _repository;

  Stream<List<OnlineMatch>> call(String playerId) =>
      _repository.watchMyActiveMatches(playerId);
}
