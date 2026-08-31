import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_outlined_button.dart";

class OauthButtonsRow extends StatelessWidget {
  const OauthButtonsRow({
    required this.oauthProviders,
    this.spacing = AppSpacing.lg,
    this.buttonSpacing = AppSpacing.md,
    this.borderRadius = AppSpacing.radiusXl,
    this.showLabel = false,
    this.showAsRow = true,
    super.key,
  });

  final List<OauthProviderInfo> oauthProviders;
  final double spacing;
  final double buttonSpacing;
  final double borderRadius;
  final bool showLabel;
  final bool showAsRow;

  @override
  Widget build(BuildContext context) {
    final cc = context.colorScheme;
    return Row(
      spacing: spacing,
      children: List.generate(oauthProviders.length, (index) {
        final (:provider, :image, :label, :onPressed) = oauthProviders[index];
        final children = [
          Image.asset(
            image,
            width: AppSpacing.xl,
            height: AppSpacing.xl,
          ),
          if (showAsRow)
            Text(
            label,
            style: context.textTheme.titleSmall!.copyWith(
              color: cc.onSurface.withValues(
                alpha: .8,
              ),
            ),
            overflow: .ellipsis,
          ),
        ];
        return Expanded(
          child: Tooltip(
            message: label,
            child: AppOutlinedButton(
              borderColor: cc.outline,
              borderRadius: borderRadius,
              onPressed: onPressed,
              child: showAsRow ? Row(
                spacing: buttonSpacing,
                mainAxisAlignment: .center,
                children: children,
              ) : Column(
                spacing: buttonSpacing,
                mainAxisAlignment: .center,
                children: children,
              ),
            ),
          ),
        );
      }),
    );
  }
}

typedef OauthProviderInfo = ({
  String provider,
  String image,
  String label,
  VoidCallback onPressed,
});
