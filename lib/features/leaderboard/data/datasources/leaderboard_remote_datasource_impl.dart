import "package:dio/dio.dart";
import "package:supabase_flutter/supabase_flutter.dart" as sb;

import "../models/leaderboard_entry_model.dart";
import "leaderboard_remote_datasource.dart";

/// Implémentation REST directe de [LeaderboardRemoteDataSource] — appelle
/// l'API PostgREST de Supabase (`/rest/v1/user_profiles`) via [Dio] plutôt
/// que le SDK `supabase_flutter`, pour démontrer un client HTTP maison
/// complet (headers, auth, refresh, logs — voir `DioClient`).
///
/// [_supabase] reste utilisé uniquement pour lire l'id de l'utilisateur
/// courant (`auth.currentUser`) — l'authentification elle-même continue de
/// passer par le SDK, seule la lecture des données change de canal.
class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  LeaderboardRemoteDataSourceImpl({
    required Dio dio,
    required sb.SupabaseClient supabaseClient,
  }) : _dio = dio,
       _supabase = supabaseClient;

  final Dio _dio;
  final sb.SupabaseClient _supabase;

  static const _columns = "id,username,avatar_url,rating";

  @override
  Future<List<LeaderboardEntryModel>> fetchTopPlayers({
    required int limit,
    required int offset,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      "/user_profiles",
      queryParameters: {
        "select": _columns,
        "order": "rating.desc",
        "offset": offset,
        "limit": limit,
      },
    );

    final rows = response.data ?? [];
    return [
      for (var i = 0; i < rows.length; i++)
        LeaderboardEntryModel.fromJson(
          rows[i] as Map<String, dynamic>,
          rank: offset + i + 1,
        ),
    ];
  }

  @override
  Future<LeaderboardEntryModel> fetchMyRank({required String userId}) async {
    final profileResponse = await _dio.get<List<dynamic>>(
      "/user_profiles",
      queryParameters: {"select": _columns, "id": "eq.$userId"},
    );
    final rows = profileResponse.data ?? [];
    if (rows.isEmpty) throw Exception("Profil introuvable");
    final profileRow = rows.first as Map<String, dynamic>;
    final myRating = profileRow["rating"] as int? ?? 500;

    // PostgREST : compte exact via le header `Prefer: count=exact`, lu en
    // retour dans `Content-Range: <start>-<end>/<total>`.
    final countResponse = await _dio.get<List<dynamic>>(
      "/user_profiles",
      queryParameters: {"select": "id", "rating": "gt.$myRating"},
      options: Options(headers: {"Prefer": "count=exact"}),
    );
    final contentRange = countResponse.headers.value("content-range");
    final total = contentRange != null && contentRange.contains("/")
        ? int.tryParse(contentRange.split("/").last) ?? 0
        : 0;

    return LeaderboardEntryModel.fromJson(profileRow, rank: total + 1);
  }

  @override
  String? getCurrentUserId() => _supabase.auth.currentUser?.id;
}
