import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/user_profile.dart";
import "../repositories/auth_repository.dart";

class CompleteOAuthSignInUseCase {
  const CompleteOAuthSignInUseCase(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, UserProfile>> call({String? username}) {
    return repository.completeOAuthSignIn(username: username);
  }
}
