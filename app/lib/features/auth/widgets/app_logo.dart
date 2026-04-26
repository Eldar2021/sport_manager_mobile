import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    this.size = 88,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size * 0.25)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary,
              colors.onPrimaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.27),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _CuePainter(colors.onPrimary),
        ),
      ),
    );
  }
}

class _CuePainter extends CustomPainter {
  _CuePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 24;
    final sy = size.height / 24;

    canvas
      ..drawLine(
        Offset(3 * sx, 21 * sy),
        Offset(21 * sx, 3 * sy),
        Paint()
          ..color = color
          ..strokeWidth = 2 * sx
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      )
      ..drawCircle(
        Offset(4.5 * sx, 19.5 * sy),
        2 * sx,
        Paint()..color = color,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
