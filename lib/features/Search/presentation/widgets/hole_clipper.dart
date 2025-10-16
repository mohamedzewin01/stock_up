import 'package:flutter/material.dart';

class HoleClipper extends CustomClipper<Path> {
  final Rect rect;

  HoleClipper({required this.rect});

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)));
    path.fillType = PathFillType.evenOdd; // الجزء داخل المستطيل يصبح شفاف
    return path;
  }

  @override
  bool shouldReclip(HoleClipper oldClipper) => oldClipper.rect != rect;
}
