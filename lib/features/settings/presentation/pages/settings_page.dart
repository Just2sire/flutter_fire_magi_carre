import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart" show BuildContextExtensions;
import "../../../../core/extensions/navigation_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/providers/index.dart"
    show appThemeModeProvider, appLocaleProvider;
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar;
import "../../../../shared/presentation/widgets/material/index.dart"
    show AppBottomSheetHandleBar;
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppSectionLabel, AppGroupedCard, AppTileRow;
import "../../../auth/presentation/providers/auth_providers.dart";

/// Écran des paramètres — apparence, langue et gestion du compte.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = context.colorScheme;
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);

    return AppScaffold(
      scrollable: true,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          AppTopbar(title: l10n.settingsTitle),
          AppSpacing.gapVXl,
          AppSectionLabel(text: l10n.settingsTheme),
          AppSpacing.gapVSm,
          AppGroupedCard(
            children: [
              AppTileRow(
                icon: switch (themeMode) {
                  ThemeMode.light => AppIcons.sun,
                  ThemeMode.dark => AppIcons.moon,
                  ThemeMode.system => AppIcons.monitor,
                },
                title: l10n.settingsTheme,
                subtitle: switch (themeMode) {
                  ThemeMode.system => l10n.settingsThemeSystem,
                  ThemeMode.light => l10n.settingsThemeLight,
                  ThemeMode.dark => l10n.settingsThemeDark,
                },
                onTap: () => _pickTheme(context, ref, themeMode),
              ),
              AppTileRow(
                icon: AppIcons.globe,
                title: l10n.settingsLanguage,
                subtitle: locale.languageCode == "fr"
                    ? l10n.settingsLanguageFr
                    : l10n.settingsLanguageEn,
                onTap: () => _pickLocale(context, ref, locale),
                isLast: true,
              ),
            ],
          ),
          AppSpacing.gapVXxl,
          AppSectionLabel(text: l10n.settingsAccountSection),
          AppSpacing.gapVSm,
          AppGroupedCard(
            children: [
              AppTileRow(
                icon: AppIcons.lockKeyhole,
                title: l10n.profileChangePasswordCta,
                onTap: () => context.pushProfileChangePassword<void>(),
              ),
              AppTileRow(
                icon: AppIcons.logout,
                title: l10n.settingsLogout,
                iconColor: cs.error,
                iconBackgroundColor: cs.error.withAlpha(31),
                titleColor: cs.error,
                onTap: () => _logout(context, ref),
                isLast: true,
              ),
            ],
          ),
          AppSpacing.gapVXxxl,
          Center(
            child: Text(
              "MagiCarré · v0.1.0",
              style: context.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          AppSpacing.gapVLg,
        ],
      ),
    );
  }

  Future<void> _pickTheme(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) async {
    final l10n = context.l10n;
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (sheetContext) => _OptionsSheet<ThemeMode>(
        title: l10n.settingsTheme,
        current: current,
        options: [
          (
            value: ThemeMode.system,
            label: l10n.settingsThemeSystem,
            icon: AppIcons.monitor,
          ),
          (
            value: ThemeMode.light,
            label: l10n.settingsThemeLight,
            icon: AppIcons.sun,
          ),
          (
            value: ThemeMode.dark,
            label: l10n.settingsThemeDark,
            icon: AppIcons.moon,
          ),
        ],
      ),
    );
    if (selected != null) {
      await ref.read(appThemeModeProvider.notifier).setTheme(selected);
    }
  }

  Future<void> _pickLocale(
    BuildContext context,
    WidgetRef ref,
    Locale current,
  ) async {
    final l10n = context.l10n;
    final selected = await showModalBottomSheet<Locale>(
      context: context,
      builder: (sheetContext) => _OptionsSheet<Locale>(
        title: l10n.settingsLanguage,
        current: current,
        options: [
          (
            value: const Locale("fr"),
            label: l10n.settingsLanguageFr,
            icon: AppIcons.globe,
          ),
          (
            value: const Locale("en"),
            label: l10n.settingsLanguageEn,
            icon: AppIcons.globe,
          ),
        ],
      ),
    );
    if (selected != null) {
      await ref.read(appLocaleProvider.notifier).setLocale(selected);
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await context.showConfirmDialog(
      title: context.l10n.settingsLogoutConfirmTitle,
      content: context.l10n.settingsLogoutConfirmMessage,
      confirmLabel: context.l10n.settingsLogout,
      cancelLabel: context.l10n.commonCancel,
      destructive: true,
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }
}

/// Bottom sheet de sélection générique (thème, langue…).
class _OptionsSheet<T> extends StatelessWidget {
  const _OptionsSheet({
    required this.title,
    required this.current,
    required this.options,
  });

  final String title;
  final T current;
  final List<({T value, String label, IconData icon})> options;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppBottomSheetHandleBar(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(title, style: context.textTheme.titleMedium),
          ),
          for (final option in options)
            ListTile(
              leading: Icon(option.icon, color: cs.primary),
              title: Text(option.label),
              trailing: option.value == current
                  ? Icon(AppIcons.check, color: cs.primary)
                  : null,
              onTap: () => Navigator.of(context).pop(option.value),
            ),
          AppSpacing.gapVSm,
        ],
      ),
    );
  }
}
