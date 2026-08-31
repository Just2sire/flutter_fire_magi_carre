import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/auth_repository.dart";

class SignInWithOAuthUseCase {
  const SignInWithOAuthUseCase(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, void>> call(AuthProvider provider) {
    return repository.signInWithOAuth(provider);
  }
}
