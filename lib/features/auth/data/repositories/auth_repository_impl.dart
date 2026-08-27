import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/auth_failure.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../../../../shared/domain/failures/server_failure.dart";
import "../../domain/entities/user_profile.dart";
import "../../domain/repositories/auth_repository.dart";
import "../datasources/auth_local_datasource.dart";
import "../datasources/auth_remote_datasource.dart";

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
  });

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, UserProfile>> signup(
    String email,
    String password, {
    String? username,
  }) async {
    try {
      final finalUsername = (username?.trim().isEmpty ?? true)
          ? _generateDefaultUsername()
          : username!;

      final profile = await _remoteDataSource.signup(
        email: email,
        password: password,
        username: finalUsername,
      );

      await _localDataSource.saveSession(
        userId: profile.id,
        username: profile.username,
        onboardingCompleted: profile.onboardingCompleted,
      );

      return Right(profile);
    } on _AuthException catch (e) {
      return Left(InvalidCredentialsFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> login(
    String email,
    String password,
  ) async {
    try {
      final profile = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      await _localDataSource.saveSession(
        userId: profile.id,
        username: profile.username,
        onboardingCompleted: profile.onboardingCompleted,
      );

      return Right(profile);
    } on _AuthException catch (e) {
      return Left(InvalidCredentialsFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearSession();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signInWithOAuth(AuthProvider provider) async {
    try {
      await _remoteDataSource.signInWithOAuth(provider);
      return const Right(null);
    } on _AuthException catch (e) {
      if (e.message.contains("cancelled")) {
        return const Left(OAuthCancelledFailure());
      }
      return Left(InvalidCredentialsFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> completeOAuthSignIn({
    String? username,
  }) async {
    try {
      final finalUsername = (username?.trim().isEmpty ?? true)
          ? _generateDefaultUsername()
          : username!;

      final profile = await _remoteDataSource.completeOAuthSignIn(
        username: finalUsername,
      );

      await _localDataSource.saveSession(
        userId: profile.id,
        username: profile.username,
        onboardingCompleted: profile.onboardingCompleted,
      );

      return Right(profile);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> completeOnboarding() async {
    try {
      final userId = _remoteDataSource.getCurrentUserId();
      if (userId == null) {
        return const Left(UserNotFoundFailure());
      }

      final profile = await _remoteDataSource.completeOnboarding(
        userId: userId,
      );

      await _localDataSource.setOnboardingCompleted(true);

      return Right(profile);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(String newPassword) async {
    try {
      await _remoteDataSource.updatePassword(newPassword);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateBio(String bio) async {
    try {
      final userId = _remoteDataSource.getCurrentUserId();
      if (userId == null) {
        return const Left(UserNotFoundFailure());
      }

      final profile = await _remoteDataSource.updateBio(
        userId: userId,
        bio: bio,
      );

      return Right(profile);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateAvatarUrl(String url) async {
    try {
      final userId = _remoteDataSource.getCurrentUserId();
      if (userId == null) {
        return const Left(UserNotFoundFailure());
      }

      final profile = await _remoteDataSource.updateAvatarUrl(
        userId: userId,
        url: url,
      );

      return Right(profile);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFriend(String friendId) async {
    try {
      final userId = _remoteDataSource.getCurrentUserId();
      if (userId == null) {
        return const Left(UserNotFoundFailure());
      }

      await _remoteDataSource.addFriend(
        userId: userId,
        friendId: friendId,
      );

      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFriend(String friendId) async {
    try {
      final userId = _remoteDataSource.getCurrentUserId();
      if (userId == null) {
        return const Left(UserNotFoundFailure());
      }

      await _remoteDataSource.removeFriend(
        userId: userId,
        friendId: friendId,
      );

      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  String _generateDefaultUsername() {
    final random = DateTime.now().millisecondsSinceEpoch % 999999;
    return "Player_${random.toString().padLeft(6, "0")}";
  }
}

class _AuthException implements Exception {
  _AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
