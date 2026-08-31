import "package:flutter/material.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";

/// Top bar MagiCarré — deux variantes visuelles :
///
/// - **Racine** (`centerTitle: false`) : titre à gauche, actions à droite,
///   pas de bordure inférieure au repos.
/// - **Poussée** (`showLeading: true`) : bouton retour, titre optionnel.
class AppTopbar extends StatelessWidget {
  const AppTopbar({
    required this.title,
    this.actions,
    this.subtitle,
    this.subTitleTextStyle,
    this.onPop,
    this.leading,
    this.titleTextStyle,
    this.spacing = 0,
    this.actionsSpacing = AppSpacing.md,
    this.titleSubtitleSpacing = AppSpacing.xs,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.showLeading = true,
    this.centerTitle = false,
    this.padding = .zero,
    this.leadingButtonTooltip,
    super.key,
  });

  final bool showLeading;
  final bool centerTitle;
  final double spacing;
  final double actionsSpacing;
  final double titleSubtitleSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final VoidCallback? onPop;
  final Widget? leading;
  final List<Widget>? actions;
  final String title;
  final String? subtitle;
  final TextStyle? titleTextStyle;
  final TextStyle? subTitleTextStyle;
  final EdgeInsets padding;
  final String? leadingButtonTooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTitleStyle =
        titleTextStyle ??
        theme.appBarTheme.titleTextStyle ??
        theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        );

    return SizedBox(
      height: AppSpacing.appBarHeight,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: centerTitle
              ? mainAxisAlignment
              : MainAxisAlignment.start,
          children: [
            if (showLeading)
              Tooltip(
                message: leadingButtonTooltip ?? "Retour",
                child:
                    leading ??
                    InkWell(
                      borderRadius: AppSpacing.roundedLg,
                      onTap: () {
                        if (onPop != null) return onPop!();
                        if (context.canPop) context.pop();
                      },
                      child: Icon(
                        AppIcons.arrowLeft,
                        size: AppSpacing.iconXl,
                        color: context.isDarkMode
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
              ),
            if (showLeading)
              SizedBox(width: spacing == 0 ? AppSpacing.sm : spacing),
            if (subtitle != null && subtitle!.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: effectiveTitleStyle),
                  SizedBox(height: titleSubtitleSpacing),
                  Text(
                    subtitle!,
                    style:
                        subTitleTextStyle ??
                        theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              )
            else
              Text(title, style: effectiveTitleStyle),
            if (!centerTitle) const Spacer(),
            if (actions != null && actions!.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < actions!.length; i++) ...[
                    actions![i],
                    if (i < actions!.length - 1)
                      SizedBox(width: actionsSpacing),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
