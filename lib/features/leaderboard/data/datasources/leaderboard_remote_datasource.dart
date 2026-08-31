import "../models/leaderboard_entry_model.dart";

/// Contrat des opérations distantes du classement.
abstract class LeaderboardRemoteDataSource {
  /// Page du classement triée par rating décroissant.
  Future<List<LeaderboardEntryModel>> fetchTopPlayers({
    required int limit,
    required int offset,
  });

  /// Rang de l'utilisateur [userId] dans le classement global.
  Future<LeaderboardEntryModel> fetchMyRank({required String userId});

  String? getCurrentUserId();
}
