import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/constants/app_keys.dart";
import "../../../core/theme/app_theme.dart";
import "storage_providers.dart";

part "theme_provider.g.dart";

/// Thème actif de l'application, persisté dans les préférences partagées.
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(AppKeys.themeMode);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  /// Change et persiste le thème.
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppKeys.themeMode, mode.name);
    state = mode;
  }

  void toggleTheme() {
    final next = state == ThemeMode.system
        ? ThemeMode.light
        : (state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    setTheme(next);
  }

  ThemeMode get theme => state;

  set theme(ThemeMode theme) {
    setTheme(theme);
  }
}

@riverpod
ThemeData lightTheme(Ref ref) => AppTheme.lightTheme;

@riverpod
ThemeData darkTheme(Ref ref) => AppTheme.darkTheme;
