import "package:dio/dio.dart";

import "auth_interceptor.dart";
import "logging_interceptor.dart";
import "refresh_interceptor.dart";

/// Fabrique des instances [Dio] configurées pour Docu.
///
/// Deux instances :
/// - [createMistralDio] — appels API Mistral OCR, token statique dans headers.
/// - [createSupabaseDio] — appels REST bruts Supabase (RPC, Edge Functions).
///
/// Ordre des intercepteurs : `auth` → `refresh` → `logging`.
/// Dio exécute `onRequest` dans l'ordre d'ajout et `onResponse`/`onError`
/// dans l'ordre inverse, ce qui garantit que `logging` capture les headers
/// finaux en request et le status final en response.
class DioClient {
  DioClient._();

  static Dio createMistralDio({
    required String baseUrl,
    required String apiKey,
    required Duration connectTimeout,
    required Duration receiveTimeout,
    required AuthInterceptor authInterceptor,
    required RefreshInterceptor refreshInterceptor,
    required LoggingInterceptor loggingInterceptor,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
      ),
    );

    dio.interceptors.addAll([
      authInterceptor,
      refreshInterceptor,
      loggingInterceptor,
    ]);

    return dio;
  }

  static Dio createSupabaseDio({
    required String baseUrl,
    required String publishableKey,
    required Duration connectTimeout,
    required Duration receiveTimeout,
    required AuthInterceptor authInterceptor,
    required RefreshInterceptor refreshInterceptor,
    required LoggingInterceptor loggingInterceptor,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          "Content-Type": "application/json",
          "apikey": publishableKey,
        },
      ),
    );

    dio.interceptors.addAll([
      authInterceptor,
      refreshInterceptor,
      loggingInterceptor,
    ]);

    return dio;
  }
}
