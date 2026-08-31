import "package:flutter/material.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";

/// Ligne d'action au sein d'un `AppGroupedCard` — icône dans un badge coloré,
/// titre, sous-titre optionnel, chevron de navigation.
class AppTileRow extends StatelessWidget {
  const AppTileRow({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
    this.subtitle,
    this.iconColor,
    this.iconBackgroundColor,
    this.titleColor,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Color? titleColor;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
              : null,
          child: Padding(
            padding: AppSpacing.insetMd,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor ?? cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: AppSpacing.iconMd,
                    color: iconColor ?? cs.primary,
                  ),
                ),
                AppSpacing.gapHMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        title,
                        style: tt.titleSmall?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: tt.labelLarge?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  AppIcons.chevronRight,
                  size: AppSpacing.iconSm,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(indent: AppSpacing.xxl + 36, height: 1),
      ],
    );
  }
}
