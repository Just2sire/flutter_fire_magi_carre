import "package:dio/dio.dart";
import "package:supabase_flutter/supabase_flutter.dart" as sb;

import "../../../../core/configs/logger.dart";

/// Refresh JWT automatique sur 401 et rejeu de la requête.
///
/// Étend [QueuedInterceptor] pour sérialiser les refreshes concurrents :
/// si N requêtes échouent en 401 simultanément, une seule déclenche le
/// refresh ; les autres attendent la résolution. Le refresh lui-même passe
/// par `supabase_flutter` (`auth.refreshSession()`), qui persiste la
/// nouvelle session — la requête rejouée lit ce même état via
/// `AuthInterceptor`.
class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor({required this.dio});

  final Dio dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final alreadyRetried = err.requestOptions.extra["retried"] == true;

    if (statusCode != 401 || alreadyRetried) {
      return handler.next(err);
    }

    try {
      final result = await sb.Supabase.instance.client.auth.refreshSession();
      final newToken = result.session?.accessToken;
      if (newToken == null) {
        throw const sb.AuthException("No session after refresh");
      }

      final retryOptions = err.requestOptions
        ..extra["retried"] = true
        ..headers["Authorization"] = "Bearer $newToken";

      final retryResponse = await dio.fetch<dynamic>(retryOptions);
      return handler.resolve(retryResponse);
    } catch (e) {
      Log.w("RefreshInterceptor: refresh échoué, session expirée. Cause: $e");
      await sb.Supabase.instance.client.auth.signOut();
      return handler.reject(err);
    }
  }
}
