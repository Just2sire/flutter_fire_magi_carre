import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/user_profile.dart";
import "../repositories/auth_repository.dart";

class SignupUseCase {
  const SignupUseCase(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, UserProfile>> call(
    String email,
    String password, {
    String? username,
  }) {
    return repository.signup(email, password, username: username);
  }
}
