import "package:dio/dio.dart";

import "auth_interceptor.dart";
import "logging_interceptor.dart";
import "refresh_interceptor.dart";

/// Fabrique une instance [Dio] pour appeler directement l'API REST de
/// Supabase (PostgREST, `/rest/v1/...`) — sans passer par le SDK
/// `supabase_flutter`, pour démontrer un client HTTP maison complet
/// (headers, auth, refresh, logs).
///
/// Ordre des intercepteurs : `auth` → `refresh` → `logging`. Dio exécute
/// `onRequest` dans l'ordre d'ajout et `onResponse`/`onError` dans l'ordre
/// inverse, ce qui garantit que `logging` capture les headers finaux en
/// requête et le status final en réponse.
class DioClient {
  DioClient._();

  static Dio createSupabaseRestDio({
    required String supabaseUrl,
    required String anonKey,
    required Duration connectTimeout,
    required Duration receiveTimeout,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: "$supabaseUrl/rest/v1",
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {"Content-Type": "application/json", "apikey": anonKey},
      ),
    );

    dio.interceptors.addAll([
      const AuthInterceptor(),
      RefreshInterceptor(dio: dio),
      const LoggingInterceptor(),
    ]);

    return dio;
  }
}
