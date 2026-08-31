import "../../domain/entities/leaderboard_entry.dart";

class LeaderboardEntryModel extends LeaderboardEntry {
  const LeaderboardEntryModel({
    required super.rank,
    required super.userId,
    required super.username,
    required super.rating,
    super.avatarUrl,
  });

  /// [rank] n'est pas stocké en base — il est calculé côté datasource
  /// (position dans la page triée, ou décompte des ratings supérieurs).
  factory LeaderboardEntryModel.fromJson(
    Map<String, dynamic> json, {
    required int rank,
  }) {
    return LeaderboardEntryModel(
      rank: rank,
      userId: json["id"] as String,
      username: json["username"] as String,
      rating: json["rating"] as int? ?? 1000,
      avatarUrl: json["avatar_url"] as String?,
    );
  }
}
