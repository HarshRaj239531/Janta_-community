import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomLogo extends StatelessWidget {
  final double size;

  const CustomLogo({
    super.key,
    this.size = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Define the stroke width proportional to the widget size
    final strokeWidth = w * 0.13;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = const LinearGradient(
        colors: AppColors.goldGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Draw top hook (representing 'P' / top bar)
    // Horizontal bar at y = 0.35 * h, looping down on the left to y = 0.52 * h
    final topPath = Path();
    topPath.moveTo(w * 0.44, h * 0.52);
    topPath.quadraticBezierTo(
      w * 0.28, h * 0.52,
      w * 0.28, h * 0.435,
    );
    topPath.quadraticBezierTo(
      w * 0.28, h * 0.35,
      w * 0.44, h * 0.35,
    );
    topPath.lineTo(w * 0.72, h * 0.35);
    canvas.drawPath(topPath, paint);

    // Draw bottom hook (representing 'F' / bottom bar)
    // Horizontal bar at y = 0.55 * h, looping down on the left to y = 0.72 * h
    final bottomPath = Path();
    bottomPath.moveTo(w * 0.44, h * 0.72);
    bottomPath.quadraticBezierTo(
      w * 0.28, h * 0.72,
      w * 0.28, h * 0.635,
    );
    bottomPath.quadraticBezierTo(
      w * 0.28, h * 0.55,
      w * 0.44, h * 0.55,
    );
    bottomPath.lineTo(w * 0.72, h * 0.55);
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
