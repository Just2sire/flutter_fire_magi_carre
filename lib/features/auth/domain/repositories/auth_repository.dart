import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/user_profile.dart";

/// Providers OAuth supportés.
enum AuthProvider { google, github, apple }

abstract class AuthRepository {
  Future<Either<Failure, UserProfile>> signup(
    String email,
    String password, {
    String? username,
  });
  Future<Either<Failure, UserProfile>> login(
    String email,
    String password,
  );
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> signInWithOAuth(AuthProvider provider);
  Future<Either<Failure, UserProfile>> completeOAuthSignIn({String? username});
  Future<Either<Failure, UserProfile>> completeOnboarding();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, void>> updatePassword(String newPassword);
  Future<Either<Failure, UserProfile>> updateBio(String bio);
  Future<Either<Failure, UserProfile>> updateAvatarUrl(String url);
  Future<Either<Failure, void>> addFriend(String friendId);
  Future<Either<Failure, void>> removeFriend(String friendId);
}
