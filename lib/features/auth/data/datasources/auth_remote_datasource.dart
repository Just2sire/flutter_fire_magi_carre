import "dart:typed_data";

import "package:supabase_flutter/supabase_flutter.dart" as sb;

import "../../domain/repositories/auth_repository.dart";
import "../models/user_profile_model.dart";

/// Contrat des opérations distantes d'authentification.
abstract class AuthRemoteDataSource {
  Future<UserProfileModel> signup({
    required String email,
    required String password,
    required String username,
  });

  Future<UserProfileModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> signInWithOAuth(AuthProvider provider);

  Future<UserProfileModel> completeOAuthSignIn({required String username});

  Future<UserProfileModel> fetchProfile({required String userId});

  Future<UserProfileModel> completeOnboarding({required String userId});

  Future<void> resetPassword(String email);

  Future<void> updatePassword(String newPassword);

  Future<UserProfileModel> updateBio({
    required String userId,
    required String bio,
  });

  Future<UserProfileModel> updateUsername({
    required String userId,
    required String username,
  });

  Future<UserProfileModel> updateAvatarUrl({
    required String userId,
    required String url,
  });

  /// Upload une image d'avatar dans le bucket Storage et retourne son URL
  /// publique.
  Future<String> uploadAvatarImage({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
  });

  Future<void> addFriend({
    required String userId,
    required String friendId,
  });

  Future<void> removeFriend({
    required String userId,
    required String friendId,
  });

  String? getCurrentUserId();

  /// Stream des changements de session Supabase bruts.
  Stream<sb.AuthState> watchAuthState();
}
