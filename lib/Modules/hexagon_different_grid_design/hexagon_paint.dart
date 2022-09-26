import 'package:flutter/cupertino.dart';
import 'package:hexagon_different_grid_design/Modules/hexagon_different_grid_design/hexagon_custom_painter.dart';
import 'dart:ui' as ui;

class HexagonPaintDifferentDesign extends StatelessWidget {
  final Offset center;
  final double radius;
  final ui.Image? backgroundImage;

  HexagonPaintDifferentDesign(this.center, this.radius, [this.backgroundImage]);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HexagonPainterDifferentDesign(center, radius, backgroundImage),
    );
  }
}