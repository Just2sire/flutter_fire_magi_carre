import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";

/// Tuile pliable animée : un en-tête cliquable dévoile/masque une liste
/// d'items générés à la demande.
///
/// Deux modes de contrôle :
/// - **auto** (par défaut) : ne pas fournir [onToggle]. Le widget gère
///   lui-même son état d'expansion à partir de [initiallyExpanded].
/// - **contrôlé** : fournir [onToggle] et piloter [isExpanded] depuis le
///   parent. Le widget se contente de refléter la valeur.
class AppCollapsibleTile<T> extends StatefulWidget {
  const AppCollapsibleTile({
    required this.title,
    required this.items,
    required this.itemBuilder,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.separatorBuilder,
    this.emptyPlaceholder,
    // Contrôle
    this.onToggle,
    this.isExpanded = false,
    this.initiallyExpanded = false,
    // Style
    this.backgroundColor,
    this.expandedBorderColor,
    this.expandedBorderWidth = AppSpacing.borderWidthMedium,
    this.borderRadius = AppSpacing.radiusLg,
    this.elevation = AppSpacing.elevationXs,
    this.margin = EdgeInsets.zero,
    this.contentPadding = AppSpacing.listItemPaddingSm,
    this.showBorderWhenExpanded = true,
    this.showCard = true,
    // Animation
    this.duration = AppSpacing.durationBase,
    this.curve = AppSpacing.curveDefault,
    this.expandedIcon,
    this.collapsedIcon,
  });

  // ─── Contenu ─────────────────────────────────────────────────
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;

  /// Remplace intégralement l'icône de dépliage par défaut si fourni.
  final Widget? trailing;

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Widget affiché à la place de la liste quand [items] est vide.
  final Widget? emptyPlaceholder;

  // ─── Contrôle ────────────────────────────────────────────────

  /// Fourni ⇒ mode contrôlé : [isExpanded] pilote l'état.
  final ValueChanged<bool>? onToggle;

  /// Ignoré en mode auto (voir [initiallyExpanded]).
  final bool isExpanded;

  /// État initial en mode auto uniquement.
  final bool initiallyExpanded;

  // ─── Style ───────────────────────────────────────────────────
  final Color? backgroundColor;

  /// Couleur du liseré affiché autour de la tuile quand elle est ouverte.
  /// Défaut : `colorScheme.primary` avec 40 % d'opacité.
  final Color? expandedBorderColor;

  final double expandedBorderWidth;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry contentPadding;

  /// Coupe le liseré d'ouverture (utile pour un rendu plat).
  final bool showBorderWhenExpanded;

  /// Enveloppe l'en-tête dans un [Card]. Passer `false` pour un rendu inline
  /// sans ombre ni radius de fond.
  final bool showCard;

  // ─── Animation ───────────────────────────────────────────────
  final Duration duration;
  final Curve curve;

  /// Icône affichée quand la tuile est ouverte. Si `expandedIcon` **et**
  /// `collapsedIcon` sont fournis, un cross-fade est appliqué entre les deux.
  /// Sinon, un chevron par défaut effectue une rotation de 180°.
  final Widget? expandedIcon;

  /// Icône affichée quand la tuile est fermée. Voir [expandedIcon].
  final Widget? collapsedIcon;

  @override
  State<AppCollapsibleTile<T>> createState() => _AppCollapsibleTileState<T>();
}

class _AppCollapsibleTileState<T> extends State<AppCollapsibleTile<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _rotationAnimation;

  late bool _expanded;

  bool get _isControlled => widget.onToggle != null;
  bool get _isExpanded => _isControlled ? widget.isExpanded : _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = _isControlled ? widget.isExpanded : widget.initiallyExpanded;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _sizeAnimation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    if (_isExpanded) _controller.value = 1;
  }

  @override
  void didUpdateWidget(covariant AppCollapsibleTile<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (_isControlled && widget.isExpanded != oldWidget.isExpanded) {
      _animate(expanded: widget.isExpanded);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animate({required bool expanded}) {
    if (expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _handleTap() {
    final next = !_isExpanded;
    if (_isControlled) {
      widget.onToggle!(next);
    } else {
      setState(() => _expanded = next);
      _animate(expanded: next);
    }
  }

  Widget _defaultChevron() {
    return RotationTransition(
      turns: _rotationAnimation,
      child: const Icon(LucideIcons.chevronDown, size: AppSpacing.iconMd),
    );
  }

  Widget _crossFadeIcons() {
    return AnimatedSwitcher(
      duration: widget.duration,
      switchInCurve: widget.curve,
      switchOutCurve: widget.curve,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: KeyedSubtree(
        key: ValueKey<bool>(_isExpanded),
        child: _isExpanded ? widget.expandedIcon! : widget.collapsedIcon!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final radius = BorderRadius.circular(widget.borderRadius);

    final hasCrossFadeIcons =
        widget.expandedIcon != null && widget.collapsedIcon != null;
    final resolvedTrailing = widget.trailing ??
        (hasCrossFadeIcons ? _crossFadeIcons() : _defaultChevron());

    final effectiveBorderColor =
        widget.expandedBorderColor ?? colorScheme.primary.withAlpha(100);

    final header = ListTile(
      splashColor: colorScheme.surface,
      contentPadding: EdgeInsets.zero,// widget.contentPadding,
      leading: widget.leading,
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: resolvedTrailing,
      onTap: _handleTap,
      shape: widget.showCard
          ? null
          : RoundedRectangleBorder(borderRadius: radius),
    );

    final body = SizeTransition(
      sizeFactor: _sizeAnimation,
      child: widget.items.isEmpty
          ? (widget.emptyPlaceholder ?? const SizedBox.shrink())
          : ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) => widget.itemBuilder(
                context,
                widget.items[index],
                index,
              ),
              separatorBuilder: widget.separatorBuilder ??
                  (context, index) => const Divider(height: 1),
            ),
    );

    final wrappedHeader = widget.showCard
        ? Card(
            color: widget.backgroundColor,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: radius),
            elevation: widget.elevation,
            child: header,
          )
        : Material(
            color: widget.backgroundColor ?? Colors.transparent,
            borderRadius: radius,
            child: header,
          );

    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.showBorderWhenExpanded && _isExpanded
              ? effectiveBorderColor
              : Colors.transparent,
          width: widget.expandedBorderWidth,
        ),
        borderRadius: radius,
      ),
      child: Column(
        children: [wrappedHeader, body],
      ),
    );
  }
}
