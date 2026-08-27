import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";

class AppBottomSheetHandleBar extends StatelessWidget {
  const AppBottomSheetHandleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: theme.colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
