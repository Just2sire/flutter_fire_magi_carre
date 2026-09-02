import "package:flutter/material.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../material/app_bottom_sheet_handle_bar.dart";

/// Bottom sheet de sélection générique (thème, langue, difficulté…).
class AppOptionsSheet<T> extends StatelessWidget {
  const AppOptionsSheet({
    required this.title,
    required this.current,
    required this.options,
    super.key,
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
