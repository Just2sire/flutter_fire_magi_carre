class UserProfile {
  const UserProfile({
    required this.id,
    required this.username,
    required this.rating,
    required this.onboardingCompleted,
    required this.friendsCount,
    required this.createdAt,
    required this.updatedAt,
    this.bio,
    this.avatarUrl,
  });
  final String id;
  final String username;
  final String? bio;
  final String? avatarUrl;
  final int rating;
  final bool onboardingCompleted;
  final int friendsCount; // calculé à partir des amis
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile copyWith({
    String? username,
    String? bio,
    String? avatarUrl,
    int? rating,
    bool? onboardingCompleted,
    int? friendsCount,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      friendsCount: friendsCount ?? this.friendsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
