import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";

/// Carte arrondie regroupant une liste d'éléments (ex. `AppTileRow`),
/// avec bordure fine — utilisée pour les sections de type "Paramètres".
class AppGroupedCard extends StatelessWidget {
  const AppGroupedCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: AppSpacing.roundedXl,
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}
