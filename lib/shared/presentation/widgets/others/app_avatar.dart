import "package:flutter/material.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";

/// Avatar circulaire — affiche l'image distante si présente, sinon une
/// icône de repli. Utilisé pour tout profil affiché dans l'app (le sien,
/// celui d'un autre joueur dans le classement, etc.).
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.avatarUrl,
    super.key,
    this.radius = AppSpacing.mega,
    this.onEdit,
    this.isEditable = false,
  });

  final String? avatarUrl;
  final double radius;
  final VoidCallback? onEdit;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final url = avatarUrl;

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: cs.surfaceContainerHighest,
          backgroundImage: url != null && url.isNotEmpty
              ? NetworkImage(url)
              : null,
          child: url == null || url.isEmpty
              ? Icon(AppIcons.user, size: radius, color: cs.onSurfaceVariant)
              : null,
        ),
        if (isEditable)
          Positioned(
            bottom: 0,
            right: 0,
            child: Tooltip(
              message: context.l10n.profileEditCta,
              child: InkWell(
                onTap: onEdit,
                borderRadius: AppSpacing.roundedFull,
                child: Container(
                  padding: AppSpacing.insetSm,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainer,
                    shape: .circle,
                  ),
                  child: Icon(
                    AppIcons.edit,
                    size: AppSpacing.iconMd,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
