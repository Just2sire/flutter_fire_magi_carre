import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../providers/connectivity_provider.dart";

/// Bandeau affiché quand l'appareil est hors-ligne — à placer en haut d'un
/// écran dont les données peuvent provenir du cache local.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    if (isOnline) return const SizedBox.shrink();

    final cs = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: cs.errorContainer,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.alertCircle,
            size: AppSpacing.iconSm,
            color: cs.onErrorContainer,
          ),
          AppSpacing.gapHSm,
          Expanded(
            child: Text(
              context.l10n.commonOfflineBanner,
              style: context.textTheme.labelMedium?.copyWith(
                color: cs.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
