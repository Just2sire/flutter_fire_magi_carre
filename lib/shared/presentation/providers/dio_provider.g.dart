// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Client Dio configuré pour appeler l'API REST Supabase directement
/// (`AuthInterceptor` + `RefreshInterceptor` + `LoggingInterceptor`).

@ProviderFor(supabaseRestDio)
final supabaseRestDioProvider = SupabaseRestDioProvider._();

/// Client Dio configuré pour appeler l'API REST Supabase directement
/// (`AuthInterceptor` + `RefreshInterceptor` + `LoggingInterceptor`).

final class SupabaseRestDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Client Dio configuré pour appeler l'API REST Supabase directement
  /// (`AuthInterceptor` + `RefreshInterceptor` + `LoggingInterceptor`).
  SupabaseRestDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseRestDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseRestDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return supabaseRestDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$supabaseRestDioHash() => r'd4cb0022df42c14fdd6c799641600ec582ef8351';
