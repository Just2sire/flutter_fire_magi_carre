import "package:dio/dio.dart";
import "package:supabase_flutter/supabase_flutter.dart" as sb;

/// Injecte le JWT de la session Supabase courante dans le header
/// `Authorization: Bearer <token>` de chaque requête.
///
/// Source unique de vérité : la session gérée par `supabase_flutter`
/// (persistée et rafraîchie par le SDK) — pas de copie de token dupliquée
/// dans un stockage séparé, pour éviter tout risque de désynchronisation.
class AuthInterceptor extends Interceptor {
  const AuthInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = sb.Supabase.instance.client.auth.currentSession?.accessToken;
    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }
}
