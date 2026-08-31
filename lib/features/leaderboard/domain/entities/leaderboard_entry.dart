/// Une ligne du classement — position d'un joueur triée par [rating].
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.username,
    required this.rating,
    this.avatarUrl,
  });

  /// Position dans le classement global (1-indexé).
  final int rank;
  final String userId;
  final String username;
  final String? avatarUrl;
  final int rating;
}
