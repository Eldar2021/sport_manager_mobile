import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 88});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size * 0.25)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brandAmber, AppColors.brandAmberDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandAmber.withValues(alpha: 0.27),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: CustomPaint(painter: _CuePainter()),
    );
  }
}

class _CuePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 24;
    final sy = size.height / 24;

    canvas
      ..drawLine(
        Offset(3 * sx, 21 * sy),
        Offset(21 * sx, 3 * sy),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2 * sx
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      )
      ..drawCircle(
        Offset(4.5 * sx, 19.5 * sy),
        2 * sx,
        Paint()..color = Colors.white,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
