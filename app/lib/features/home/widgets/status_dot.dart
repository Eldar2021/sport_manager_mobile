import 'package:flutter/material.dart';

class StatusDot extends StatefulWidget {
  const StatusDot({
    required this.color,
    required this.pulse,
    super.key,
  });

  final Color color;
  final bool pulse;

  @override
  State<StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<StatusDot> with SingleTickerProviderStateMixin {
  static const double _dotSize = 8;
  static const double _maxExtension = 7;
  static const double _boxSize = _dotSize + _maxExtension * 2;

  AnimationController? _controller;
  late Animation<double> _ringExtension;
  late Animation<double> _ringOpacity;

  @override
  void initState() {
    super.initState();
    if (widget.pulse) _startAnimation();
  }

  @override
  void didUpdateWidget(StatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pulse == widget.pulse) return;
    if (widget.pulse) {
      _startAnimation();
    } else {
      _controller?.dispose();
      _controller = null;
    }
  }

  void _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _ringExtension = Tween<double>(begin: 0, end: _maxExtension).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeOut),
    );
    _ringOpacity = Tween<double>(begin: 0.5, end: 0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.pulse) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
        child: const SizedBox(
          width: _dotSize,
          height: _dotSize,
        ),
      );
    }
    return AnimatedBuilder(
      animation: _controller!,
      builder: (_, _) {
        final ringSize = _dotSize + _ringExtension.value * 2;
        return SizedBox(
          width: _boxSize,
          height: _boxSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(
                    alpha: _ringOpacity.value,
                  ),
                ),
                child: SizedBox(
                  width: ringSize,
                  height: ringSize,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
                child: const SizedBox(
                  width: _dotSize,
                  height: _dotSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
