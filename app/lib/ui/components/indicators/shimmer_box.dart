import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    required this.height,
    this.width = double.infinity,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    super.key,
  });

  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, _) => Opacity(
        opacity: _opacity.value,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.outline,
            borderRadius: widget.shape == BoxShape.circle ? null : (widget.borderRadius ?? AppRadius.chipBorderRadius),
            shape: widget.shape,
          ),
          child: SizedBox(height: widget.height, width: widget.width),
        ),
      ),
    );
  }
}
