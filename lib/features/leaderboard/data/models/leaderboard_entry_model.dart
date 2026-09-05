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
      rating: json["rating"] as int? ?? 500,
      avatarUrl: json["avatar_url"] as String?,
    );
  }

  factory LeaderboardEntryModel.fromCachedJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: json["rank"] as int,
      userId: json["id"] as String,
      username: json["username"] as String,
      rating: json["rating"] as int? ?? 500,
      avatarUrl: json["avatar_url"] as String?,
    );
  }

  /// Sérialisation pour le cache local (Hive) — [rank] est inclus, à la
  /// différence de [LeaderboardEntryModel.fromJson] qui le reçoit calculé
  /// séparément.
  Map<String, dynamic> toCacheJson() => {
    "rank": rank,
    "id": userId,
    "username": username,
    "rating": rating,
    "avatar_url": avatarUrl,
  };
}
