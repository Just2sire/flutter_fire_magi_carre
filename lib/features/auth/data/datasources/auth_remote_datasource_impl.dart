import "dart:typed_data";

import "package:google_sign_in/google_sign_in.dart";
import "package:supabase_flutter/supabase_flutter.dart" as sb;

import "../../../../core/configs/app_config.dart";
import "../../domain/repositories/auth_repository.dart";
import "../models/user_profile_model.dart";
import "auth_remote_datasource.dart";

/// Scopes demandés lors de l'autorisation Google — le strict minimum pour
/// obtenir un accessToken valide en plus de l'idToken.
const List<String> _googleAuthScopes = <String>["email"];

/// Implémentation Supabase de [AuthRemoteDataSource].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required sb.SupabaseClient supabaseClient,
    GoogleSignIn? googleSignIn,
  }) : _supabase = supabaseClient,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final sb.SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;

  bool _googleSignInInitialized = false;

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
    await _supabase.auth.signInWithPassword(email: email, password: password);

    return fetchProfile(userId: _supabase.auth.currentUser!.id);
  }

  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
    if (_googleSignInInitialized) {
      await _googleSignIn.signOut();
    }
  }

  @override
  Future<void> signInWithOAuth(AuthProvider provider) {
    return switch (provider) {
      AuthProvider.google => _signInWithGoogleNative(),
      AuthProvider.github => _signInWithBrowserOAuth(sb.OAuthProvider.github),
      AuthProvider.apple => _signInWithBrowserOAuth(sb.OAuthProvider.apple),
    };
  }

  /// Connexion Google via le sélecteur de compte natif (Play Services).
  ///
  /// Récupère l'idToken + accessToken du compte choisi et les échange
  /// contre une session Supabase — pas de redirection navigateur, pas de
  /// deep link.
  Future<void> _signInWithGoogleNative() async {
    await _ensureGoogleSignInInitialized();

    final account = await _googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw const sb.AuthException(
        "Aucun idToken retourné par Google Sign-In.",
      );
    }

    final authorization =
        await account.authorizationClient.authorizationForScopes(
          _googleAuthScopes,
        ) ??
        await account.authorizationClient.authorizeScopes(_googleAuthScopes);

    await _supabase.auth.signInWithIdToken(
      provider: sb.OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );
  }

  /// `GoogleSignIn.initialize` ne doit être appelé qu'une fois par run —
  /// on le déclenche paresseusement au premier sign-in plutôt qu'au
  /// démarrage de l'app, puisqu'il nécessite [AppConfig.googleWebClientId].
  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await _googleSignIn.initialize(
      serverClientId: AppConfig.googleWebClientId,
      clientId: AppConfig.googleIosClientId.isNotEmpty
          ? AppConfig.googleIosClientId
          : null,
    );
    _googleSignInInitialized = true;
  }

  Future<void> _signInWithBrowserOAuth(sb.OAuthProvider provider) {
    return _supabase.auth.signInWithOAuth(
      provider,
      redirectTo: "magicarre://auth/callback",
    );
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
      _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: "magicarre://auth/reset-password",
      );

  @override
  Future<void> updatePassword(String newPassword) =>
      _supabase.auth.updateUser(sb.UserAttributes(password: newPassword));

  @override
  Future<UserProfileModel> updateBio({
    required String userId,
    required String bio,
  }) async {
    await _supabase.from("user_profiles").update({"bio": bio}).eq("id", userId);

    return fetchProfile(userId: userId);
  }

  @override
  Future<UserProfileModel> updateUsername({
    required String userId,
    required String username,
  }) async {
    await _supabase
        .from("user_profiles")
        .update({"username": username})
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
  Future<String> uploadAvatarImage({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final path = "$userId/avatar.$fileExtension";
    await _supabase.storage
        .from("avatars")
        .uploadBinary(
          path,
          bytes,
          fileOptions: const sb.FileOptions(upsert: true),
        );

    return _supabase.storage.from("avatars").getPublicUrl(path);
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
        .or(
          "user_id.eq.$userId,friend_id.eq.$friendId,"
          "user_id.eq.$friendId,friend_id.eq.$userId",
        );
  }

  @override
  String? getCurrentUserId() => _supabase.auth.currentUser?.id;

  @override
  Stream<sb.AuthState> watchAuthState() => _supabase.auth.onAuthStateChange;
}
