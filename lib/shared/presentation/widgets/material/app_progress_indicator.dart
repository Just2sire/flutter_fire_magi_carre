import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";

class RadialProgressAnimation extends StatefulWidget {
  const RadialProgressAnimation({
    required this.progress,
    required this.color,
    super.key,
    this.size = AppSpacing.yotta,
    this.duration = AppSpacing.durationTeraSlow,
    this.textStyle,
    this.child,
    this.backgroundColor,
    this.thickness = 10,
  });
  final double progress;
  final double size;
  final Color color;
  final TextStyle? textStyle;
  final Duration duration;
  final Widget? child;
  final Color? backgroundColor;
  final double? thickness;

  @override
  State<RadialProgressAnimation> createState() =>
      _RadialProgressAnimationState();
}

class _RadialProgressAnimationState extends State<RadialProgressAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 0.0, // Start animation from 0
    );

    // Animate to the initial progress value
    controller.animateTo(
      widget.progress,
      duration: widget.duration,
      curve: Curves.easeIn,
    );
  }

  @override
  void didUpdateWidget(covariant RadialProgressAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If progress changes, animate to the new progress value
    if (widget.progress != oldWidget.progress) {
      controller.animateTo(
        widget.progress,
        duration: widget.duration,
        curve: Curves.easeIn,
      );
    }
    // If duration also changes, update the controller's duration
    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller, // Animate the controller itself
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: controller.value,
                  strokeWidth: widget.thickness,
                  backgroundColor: widget.backgroundColor,
                  color: widget.color,
                ),
              ),
              widget.child ??
                  Text(
                    "${(controller.value * 100).toInt()}%",
                    style: widget.textStyle,
                  ),
            ],
          );
        },
      ),
    );
  }
}
