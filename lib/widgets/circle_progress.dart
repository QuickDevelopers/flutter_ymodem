import 'dart:math';

import 'package:flutter/material.dart';

class CirclePercentProgress extends StatefulWidget {
  final double progress;

  const CirclePercentProgress({Key? key, required this.progress}) : super(key: key);

  @override
  _CirclePercentProgressState createState() => _CirclePercentProgressState();
}

class _CirclePercentProgressState extends State<CirclePercentProgress> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircleProgressPaint(min(1, max(0, widget.progress))),
    );
  }
}

class _CircleProgressPaint extends CustomPainter {
  final double progress;

  _CircleProgressPaint(this.progress);

  final Paint circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 20;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2 - circlePaint.strokeWidth / 2;
    final rect = Rect.fromCircle(radius: radius, center: Offset(size.width / 2, size.height / 2));
    circlePaint.shader = null;
    circlePaint.color = Colors.grey;
    canvas.drawArc(rect, 0, pi * 2, false, circlePaint);
    circlePaint.shader = const SweepGradient(colors: [Colors.blue, Colors.blue]).createShader(rect);
    canvas.drawArc(rect, 0, pi * 2 * progress, false, circlePaint);
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPaint oldDelegate) {
    return true;
  }
}