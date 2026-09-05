import "../repositories/i_online_match_repository.dart";

/// Émet l'id d'une partie dès qu'elle assigne le joueur donné comme
/// participant — utilisé pendant l'attente en file de matchmaking.
class WatchAssignedMatch {
  const WatchAssignedMatch(this._repository);

  final IOnlineMatchRepository _repository;

  Stream<String> call(String playerId) =>
      _repository.watchAssignedMatch(playerId);
}
