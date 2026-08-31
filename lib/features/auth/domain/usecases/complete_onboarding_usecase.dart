import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/user_profile.dart";
import "../repositories/auth_repository.dart";

class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, UserProfile>> call() {
    return repository.completeOnboarding();
  }
}
