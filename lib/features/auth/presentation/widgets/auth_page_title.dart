import "package:flutter/material.dart";

class AuthPageTitle extends StatelessWidget {
  const AuthPageTitle({
    required this.title,
    required this.subtitle,
    required this.tt,
    super.key,
    this.spacing = 0,
    this.crossAxisAlignment = .start,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String title;
  final String subtitle;
  final TextTheme tt;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacing,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: .start,
      children: [
        Text(title, style: titleStyle ?? tt.headlineSmall),
        Text(subtitle, style: subtitleStyle ?? tt.bodySmall),
      ],
    );
  }
}
