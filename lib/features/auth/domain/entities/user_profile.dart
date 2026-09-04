class UserProfile {
  const UserProfile({
    required this.id,
    required this.username,
    required this.rating,
    required this.wins,
    required this.losses,
    required this.draws,
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
  final int wins;
  final int losses;
  final int draws;
  final bool onboardingCompleted;
  final int friendsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get totalGames => wins + losses + draws;

  UserProfile copyWith({
    String? username,
    String? bio,
    String? avatarUrl,
    int? rating,
    int? wins,
    int? losses,
    int? draws,
    bool? onboardingCompleted,
    int? friendsCount,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      friendsCount: friendsCount ?? this.friendsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
