import 'dart:math';

import 'package:flutter/material.dart';

class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dotCount = 12;
    const radius = 67.5;
    final center = Offset(size.width / 2, size.height / 2);

    for (var i = 0; i < dotCount; i++) {
      final angle = (i * 2 * 3.14159) / dotCount;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
