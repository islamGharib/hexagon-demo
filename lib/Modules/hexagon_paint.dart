import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'hexagon_custom_painter.dart';

class HexagonPaint extends StatelessWidget {
  final Offset center;
  final double radius;
  final ui.Image? backgroundImage;

  HexagonPaint(this.center, this.radius, [this.backgroundImage]);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HexagonPainter(center, radius, backgroundImage),
    );
  }
}