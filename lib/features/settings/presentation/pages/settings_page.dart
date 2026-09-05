import "package:carre_magic_logic/carre_magic_logic.dart" show PlayerColor;
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
import "../../../../shared/presentation/widgets/material/app_bottom_sheet_handle_bar.dart";
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppSectionLabel, AppGroupedCard, AppTileRow, AppOptionsSheet;
import "../../../auth/presentation/providers/auth_providers.dart";
import "../../../game/presentation/providers/board_theme_provider.dart";
import "../../../game/presentation/widgets/game_stone.dart";

/// Écran des paramètres — apparence, langue et gestion du compte.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = context.colorScheme;
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    final boardTheme = ref.watch(boardThemeProvider);

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
          AppSectionLabel(text: l10n.settingsGameSection),
          AppSpacing.gapVSm,
          AppGroupedCard(
            children: [
              AppTileRow(
                icon: AppIcons.boardTheme,
                title: l10n.settingsBoardTheme,
                subtitle: boardTheme.name,
                onTap: () => _pickBoardTheme(context, ref, boardTheme),
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
      builder: (sheetContext) => AppOptionsSheet<ThemeMode>(
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
      builder: (sheetContext) => AppOptionsSheet<Locale>(
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

  Future<void> _pickBoardTheme(
    BuildContext context,
    WidgetRef ref,
    BoardTheme current,
  ) async {
    final selected = await showModalBottomSheet<BoardTheme>(
      context: context,
      builder: (_) => _BoardThemeSheet(current: current),
    );
    if (selected != null) {
      await ref.read(boardThemeProvider.notifier).setTheme(selected);
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

// ─── Board theme picker ──────────────────────────────────────────────────────

/// Bottom sheet showing a preview swatch for each [BoardTheme] preset.
class _BoardThemeSheet extends StatelessWidget {
  const _BoardThemeSheet({required this.current});

  final BoardTheme current;

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
            child: Text(
              context.l10n.settingsBoardTheme,
              style: context.textTheme.titleMedium,
            ),
          ),
          for (final theme in BoardTheme.all)
            ListTile(
              leading: _MiniBoardPreview(theme: theme),
              title: Text(theme.name),
              trailing: theme.id == current.id
                  ? Icon(AppIcons.check, color: cs.primary)
                  : null,
              onTap: () => Navigator.of(context).pop(theme),
            ),
          AppSpacing.gapVSm,
        ],
      ),
    );
  }
}

// ─── Mini board preview ──────────────────────────────────────────────────────

/// A tiny 2×2 board preview showing the given [BoardTheme]'s background,
/// grid lines, and stones — used as the leading widget in the theme picker.
class _MiniBoardPreview extends StatelessWidget {
  const _MiniBoardPreview({required this.theme});

  final BoardTheme theme;

  static const double _size = 52;
  static const double _padding = 8;
  static const double _stoneSize = 13;

  double get _step => _size - _padding * 2;

  Widget _stoneAt(int row, int col, PlayerColor color) {
    final cx = _padding + col * _step;
    final cy = _padding + row * _step;
    return Positioned(
      left: cx - _stoneSize / 2,
      top: cy - _stoneSize / 2,
      width: _stoneSize,
      height: _stoneSize,
      child: GameStone(
        color: color,
        size: _stoneSize,
        overrideBase: color == PlayerColor.white
            ? theme.stone1Base
            : theme.stone2Base,
        overrideHighlight: color == PlayerColor.white
            ? theme.stone1Highlight
            : theme.stone2Highlight,
        overrideEdge: color == PlayerColor.white
            ? theme.stone1Edge
            : theme.stone2Edge,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.roundedSm,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.boardColors,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.stone1Edge.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: _padding,
            top: _padding,
            child: CustomPaint(
              size: Size.square(_step),
              painter: _MiniBoardPainter(color: theme.lineColor),
            ),
          ),
          _stoneAt(0, 0, PlayerColor.black),
          _stoneAt(0, 1, PlayerColor.black),
          _stoneAt(1, 0, PlayerColor.white),
          _stoneAt(1, 1, PlayerColor.white),
        ],
      ),
    );
  }
}

class _MiniBoardPainter extends CustomPainter {
  const _MiniBoardPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final s = size.width;
    canvas
      ..drawLine(Offset.zero, Offset(s, 0), paint)
      ..drawLine(Offset(0, s), Offset(s, s), paint)
      ..drawLine(Offset.zero, Offset(0, s), paint)
      ..drawLine(Offset(s, 0), Offset(s, s), paint)
      ..drawLine(Offset.zero, Offset(s, s), paint);
  }

  @override
  bool shouldRepaint(covariant _MiniBoardPainter old) => old.color != color;
}
