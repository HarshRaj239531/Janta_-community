import 'package:flutter/material.dart';

class Sparkline extends StatelessWidget {
  final List<double> data;
  final Color color;
  final double strokeWidth;

  const Sparkline({
    super.key,
    required this.data,
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 24),
      painter: _SparklinePainter(data: data, color: color, strokeWidth: strokeWidth),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double strokeWidth;

  _SparklinePainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    final double stepX = size.width / (data.length - 1);
    
    // Find min and max to normalize data to size height
    double minVal = data[0];
    double maxVal = data[0];
    for (var val in data) {
      if (val < minVal) minVal = val;
      if (val > maxVal) maxVal = val;
    }
    
    double range = maxVal - minVal;
    if (range == 0) range = 1.0;

    double normalize(double val) {
      // Return normalized Y coordinate (inverted because flutter coordinates start at top left)
      double ratio = (val - minVal) / range;
      return size.height - (ratio * (size.height - 4)) - 2; 
    }

    path.moveTo(0, normalize(data[0]));

    for (int i = 0; i < data.length - 1; i++) {
      double x1 = i * stepX;
      double y1 = normalize(data[i]);
      double x2 = (i + 1) * stepX;
      double y2 = normalize(data[i + 1]);
      
      // Control points for a smooth cubic bezier curve
      double cx1 = x1 + (x2 - x1) / 2.0;
      double cy1 = y1;
      double cx2 = x1 + (x2 - x1) / 2.0;
      double cy2 = y2;
      
      path.cubicTo(cx1, cy1, cx2, cy2, x2, y2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}
