import "package:supabase_flutter/supabase_flutter.dart" as sb;

import "../models/leaderboard_entry_model.dart";
import "leaderboard_remote_datasource.dart";

/// Implémentation Supabase de [LeaderboardRemoteDataSource].
class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  LeaderboardRemoteDataSourceImpl({required sb.SupabaseClient supabaseClient})
    : _supabase = supabaseClient;

  final sb.SupabaseClient _supabase;

  static const _columns = "id, username, avatar_url, rating";

  @override
  Future<List<LeaderboardEntryModel>> fetchTopPlayers({
    required int limit,
    required int offset,
  }) async {
    final rows = await _supabase
        .from("user_profiles")
        .select(_columns)
        .order("rating", ascending: false)
        .range(offset, offset + limit - 1);

    return [
      for (var i = 0; i < rows.length; i++)
        LeaderboardEntryModel.fromJson(rows[i], rank: offset + i + 1),
    ];
  }

  @override
  Future<LeaderboardEntryModel> fetchMyRank({required String userId}) async {
    final profileRow = await _supabase
        .from("user_profiles")
        .select(_columns)
        .eq("id", userId)
        .single();

    final myRating = profileRow["rating"] as int? ?? 1000;

    final response = await _supabase
        .from("user_profiles")
        .select("id")
        .gt("rating", myRating)
        .count(sb.CountOption.exact);

    return LeaderboardEntryModel.fromJson(
      profileRow,
      rank: response.count + 1,
    );
  }

  @override
  String? getCurrentUserId() => _supabase.auth.currentUser?.id;
}
