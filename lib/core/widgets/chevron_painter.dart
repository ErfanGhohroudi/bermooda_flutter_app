import 'package:flutter/material.dart';

import '../core.dart';

class ChevronPainter extends CustomPainter {
  final Color color;

  ChevronPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    if (isPersianLang) {
      path.moveTo(5, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width - 5, size.height / 2);
      path.lineTo(size.width, size.height);
      path.lineTo(5, size.height);
      path.lineTo(0, size.height / 2);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width - 5, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - 5, size.height);
      path.lineTo(0, size.height);
      path.lineTo(5, size.height / 2);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant final ChevronPainter oldDelegate) {
    return oldDelegate.color != color; // چک کردن تغییر رنگ
  }
}