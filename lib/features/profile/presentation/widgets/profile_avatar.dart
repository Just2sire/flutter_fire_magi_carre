import "package:flutter/material.dart";
import "package:magi_carre/core/theme/app_spacing.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";

/// Avatar circulaire d'un profil — affiche l'image distante si présente,
/// sinon une icône de repli.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.avatarUrl,
    super.key,
    this.radius = AppSpacing.mega,
  });

  final String? avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final url = avatarUrl;

    return CircleAvatar(
      radius: radius,
      backgroundColor: cs.surfaceContainerHighest,
      backgroundImage: url != null && url.isNotEmpty ? NetworkImage(url) : null,
      child: url == null || url.isEmpty
          ? Icon(AppIcons.user, size: radius, color: cs.onSurfaceVariant)
          : null,
    );
  }
}
