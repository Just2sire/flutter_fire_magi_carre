import "../../domain/entities/user_profile.dart";

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.username,
    required super.rating,
    required super.wins,
    required super.losses,
    required super.draws,
    required super.onboardingCompleted,
    required super.friendsCount,
    required super.createdAt,
    required super.updatedAt,
    super.bio,
    super.avatarUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json["id"] as String,
      username: json["username"] as String,
      rating: json["rating"] as int? ?? 500,
      wins: json["wins"] as int? ?? 0,
      losses: json["losses"] as int? ?? 0,
      draws: json["draws"] as int? ?? 0,
      onboardingCompleted: json["onboarding_completed"] as bool? ?? false,
      friendsCount: json["friends_count"] as int? ?? 0,
      createdAt: DateTime.parse(json["created_at"] as String),
      updatedAt: DateTime.parse(json["updated_at"] as String),
      bio: json["bio"] as String?,
      avatarUrl: json["avatar_url"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "bio": bio,
    "avatar_url": avatarUrl,
    "rating": rating,
    "wins": wins,
    "losses": losses,
    "draws": draws,
    "onboarding_completed": onboardingCompleted,
    "friends_count": friendsCount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
