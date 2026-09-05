// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BoardThemeNotifier)
final boardThemeProvider = BoardThemeNotifierProvider._();

final class BoardThemeNotifierProvider
    extends $NotifierProvider<BoardThemeNotifier, BoardTheme> {
  BoardThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'boardThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$boardThemeNotifierHash();

  @$internal
  @override
  BoardThemeNotifier create() => BoardThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BoardTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BoardTheme>(value),
    );
  }
}

String _$boardThemeNotifierHash() =>
    r'4ec9437f6c569e06c3db65ead63af45dc78a3366';

abstract class _$BoardThemeNotifier extends $Notifier<BoardTheme> {
  BoardTheme build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BoardTheme, BoardTheme>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BoardTheme, BoardTheme>,
              BoardTheme,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
