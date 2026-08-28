import "package:supabase_flutter/supabase_flutter.dart" as sb;

import "../../domain/repositories/auth_repository.dart";
import "../models/user_profile_model.dart";
import "auth_remote_datasource.dart";

/// Implémentation Supabase de [AuthRemoteDataSource].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required sb.SupabaseClient supabaseClient})
      : _supabase = supabaseClient;

  final sb.SupabaseClient _supabase;

  @override
  Future<UserProfileModel> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final userId = response.user!.id;

    await _supabase.from("user_profiles").insert({
      "id": userId,
      "username": username,
      "bio": null,
      "avatar_url": null,
      "rating": 1000,
      "onboarding_completed": false,
    });

    return fetchProfile(userId: userId);
  }

  @override
  Future<UserProfileModel> login({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return fetchProfile(userId: _supabase.auth.currentUser!.id);
  }

  @override
  Future<void> logout() => _supabase.auth.signOut();

  @override
  Future<void> signInWithOAuth(AuthProvider provider) async {
    final supabaseProvider = switch (provider) {
      AuthProvider.google => sb.OAuthProvider.google,
      AuthProvider.github => sb.OAuthProvider.github,
      AuthProvider.apple => sb.OAuthProvider.apple,
    };

    await _supabase.auth.signInWithOAuth(supabaseProvider);
  }

  @override
  Future<UserProfileModel> completeOAuthSignIn({
    required String username,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("No authenticated user after OAuth");

    final userId = user.id;

    final existing = await _supabase
        .from("user_profiles")
        .select()
        .eq("id", userId)
        .maybeSingle();

    if (existing == null) {
      final avatarUrl = user.userMetadata?["avatar_url"] as String?;
      await _supabase.from("user_profiles").insert({
        "id": userId,
        "username": username,
        "bio": null,
        "avatar_url": avatarUrl,
        "rating": 1000,
        "onboarding_completed": false,
      });
    } else {
      final avatarUrl = user.userMetadata?["avatar_url"] as String?;
      if (avatarUrl != null && existing["avatar_url"] == null) {
        await _supabase
            .from("user_profiles")
            .update({"avatar_url": avatarUrl})
            .eq("id", userId);
      }
    }

    return fetchProfile(userId: userId);
  }

  @override
  Future<UserProfileModel> fetchProfile({required String userId}) async {
    final data = await _supabase
        .from("user_profiles")
        .select()
        .eq("id", userId)
        .single();

    return UserProfileModel.fromJson(data);
  }

  @override
  Future<UserProfileModel> completeOnboarding({required String userId}) async {
    await _supabase
        .from("user_profiles")
        .update({"onboarding_completed": true})
        .eq("id", userId);

    return fetchProfile(userId: userId);
  }

  @override
  Future<void> resetPassword(String email) =>
      _supabase.auth.resetPasswordForEmail(email);

  @override
  Future<void> updatePassword(String newPassword) =>
      _supabase.auth.updateUser(sb.UserAttributes(password: newPassword));

  @override
  Future<UserProfileModel> updateBio({
    required String userId,
    required String bio,
  }) async {
    await _supabase
        .from("user_profiles")
        .update({"bio": bio})
        .eq("id", userId);

    return fetchProfile(userId: userId);
  }

  @override
  Future<UserProfileModel> updateAvatarUrl({
    required String userId,
    required String url,
  }) async {
    await _supabase
        .from("user_profiles")
        .update({"avatar_url": url})
        .eq("id", userId);

    return fetchProfile(userId: userId);
  }

  @override
  Future<void> addFriend({
    required String userId,
    required String friendId,
  }) async {
    await _supabase.from("friendships").insert({
      "user_id": userId,
      "friend_id": friendId,
    });
  }

  @override
  Future<void> removeFriend({
    required String userId,
    required String friendId,
  }) async {
    await _supabase
        .from("friendships")
        .delete()
        .or("user_id.eq.$userId,friend_id.eq.$friendId,"
            "user_id.eq.$friendId,friend_id.eq.$userId");
  }

  @override
  String? getCurrentUserId() => _supabase.auth.currentUser?.id;

  @override
  Stream<sb.AuthState> watchAuthState() => _supabase.auth.onAuthStateChange;
}
