import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_online_match_repository.dart";

/// Rejoint une partie par son code d'invitation, retourne l'id du match.
class JoinInviteMatch {
  const JoinInviteMatch(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, String>> call(String inviteCode) {
    return _repository.joinInviteMatch(inviteCode);
  }
}
