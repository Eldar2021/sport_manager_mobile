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
              context.colors.primary,
              context.colors.onPrimaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(alpha: AppOpacity.brandGlow),
              blurRadius: AppSpacing.x6,
              offset: const Offset(0, AppSpacing.x3),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _CuePainter(context.colors.onPrimary),
        ),
      ),
    );
  }
}

/// Draws the brand mark: a billiard cue (diagonal line) plus a cue ball
/// (small filled circle at the bottom-left), in a 24×24 reference grid that
/// scales to the surrounding box.
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
