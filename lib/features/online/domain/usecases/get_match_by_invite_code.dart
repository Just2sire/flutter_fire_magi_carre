import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/online_match.dart";
import "../repositories/i_online_match_repository.dart";

/// Retrouve une partie en attente par son code d'invitation.
class GetMatchByInviteCode {
  const GetMatchByInviteCode(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, OnlineMatch>> call(String inviteCode) {
    return _repository.getMatchByInviteCode(inviteCode);
  }
}
