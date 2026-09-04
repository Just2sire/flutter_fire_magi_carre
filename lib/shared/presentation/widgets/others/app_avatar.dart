import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";

/// Avatar circulaire — affiche l'image distante si présente, sinon une
/// icône de repli. L'image est mise en cache sur disque dès le premier
/// chargement et servie localement lors des ouvertures suivantes.
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
    final diameter = radius * 2;

    final Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: cs.surfaceContainerHighest,
      child: url != null && url.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: url,
                width: diameter,
                height: diameter,
                fit: BoxFit.cover,
                placeholder: (_, _) => _Fallback(
                  radius: radius,
                  color: cs.onSurfaceVariant,
                ),
                errorWidget: (_, _, _) => _Fallback(
                  radius: radius,
                  color: cs.onSurfaceVariant,
                ),
              ),
            )
          : _Fallback(radius: radius, color: cs.onSurfaceVariant),
    );

    if (!isEditable) return avatar;

    return Stack(
      children: [
        avatar,
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
                  shape: BoxShape.circle,
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

class _Fallback extends StatelessWidget {
  const _Fallback({required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(AppIcons.user, size: radius, color: color);
  }
}
