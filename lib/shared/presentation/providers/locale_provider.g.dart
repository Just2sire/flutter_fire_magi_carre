// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Locale active de l'application, persistée dans les préférences partagées.
///
/// Défaut : `fr`. Langues supportées : `fr`, `en`.

@ProviderFor(AppLocale)
final appLocaleProvider = AppLocaleProvider._();

/// Locale active de l'application, persistée dans les préférences partagées.
///
/// Défaut : `fr`. Langues supportées : `fr`, `en`.
final class AppLocaleProvider extends $NotifierProvider<AppLocale, Locale> {
  /// Locale active de l'application, persistée dans les préférences partagées.
  ///
  /// Défaut : `fr`. Langues supportées : `fr`, `en`.
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  AppLocale create() => AppLocale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$appLocaleHash() => r'0e871dd8c5f251880cd2ca0705e5cba288840800';

/// Locale active de l'application, persistée dans les préférences partagées.
///
/// Défaut : `fr`. Langues supportées : `fr`, `en`.

abstract class _$AppLocale extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
