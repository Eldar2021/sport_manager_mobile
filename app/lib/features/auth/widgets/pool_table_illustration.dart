import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class PoolTableIllustration extends StatelessWidget {
  const PoolTableIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 160,
      child: CustomPaint(painter: _PoolTablePainter()),
    );
  }
}

class _PoolTablePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // ViewBox 160×128, scaled to 200×160
    final sx = size.width / 160;
    final sy = size.height / 128;

    final felt = RRect.fromLTRBR(
      10 * sx,
      20 * sy,
      150 * sx,
      108 * sy,
      Radius.circular(8 * sx),
    );

    // Felt fill + border
    canvas
      ..drawRRect(felt, Paint()..color = AppColors.successLight)
      ..drawRRect(
        felt,
        Paint()
          ..color = AppColors.successGreen
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

    // 6 pockets: top-left, top-mid, top-right, bottom-left, bottom-mid, bottom-right
    final pocketPaint = Paint()..color = AppColors.ink900;
    const pockets = [
      [18.0, 28.0],
      [80.0, 28.0],
      [142.0, 28.0],
      [18.0, 100.0],
      [80.0, 100.0],
      [142.0, 100.0],
    ];
    for (final p in pockets) {
      canvas.drawCircle(Offset(p[0] * sx, p[1] * sy), 5 * sx, pocketPaint);
    }

    // Balls
    canvas
      ..drawCircle(Offset(55 * sx, 64 * sy), 7 * sx, Paint()..color = Colors.white)
      ..drawCircle(
        Offset(55 * sx, 64 * sy),
        7 * sx,
        Paint()
          ..color = AppColors.ink300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      )
      ..drawCircle(Offset(75 * sx, 58 * sy), 7 * sx, Paint()..color = AppColors.dangerRed)
      ..drawCircle(Offset(75 * sx, 70 * sy), 7 * sx, Paint()..color = AppColors.warningAmber)
      ..drawCircle(Offset(95 * sx, 64 * sy), 7 * sx, Paint()..color = AppColors.brandAmber);

    // "8" label on white ball
    final tp = TextPainter(
      text: TextSpan(
        text: '8',
        style: TextStyle(
          fontSize: 7 * sx,
          fontWeight: FontWeight.w700,
          color: AppColors.ink900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(55 * sx - tp.width / 2, 64 * sy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
