import 'package:flutter/cupertino.dart';
import 'package:hexagon_different_grid_design/Modules/hexagon_different_grid_design/hexagon_custom_painter.dart';
import 'package:hexagon_different_grid_design/Modules/hexagon_different_grid_design/hexagon_paint.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;


class HexagonGridDifferentDesign extends StatelessWidget {
  static const int nrX = 8;
  static const int nrY = 10;
  static const int marginY = 0;
  static const int marginX = 0;
  final double screenWidth;
  final double screenHeight;
  final double radius;
  final double height;
  final double cornerLength;
  final ui.Image? backgroundImage;

  final List<HexagonPaintDifferentDesign> hexagons = [];

  HexagonGridDifferentDesign(this.screenWidth, this.screenHeight, [this.backgroundImage])
      : radius = computeRadius(screenWidth, screenHeight),
        height = computeHeight(computeRadius(screenWidth, screenHeight)),
        cornerLength = computeCornerLength(computeRadius(screenWidth, screenHeight)) {
    for (int y = 0; y < nrY; y++) {
      for (int x = 0; x < nrX; x++) {
        if((x==2 && y==4) || (x==4 && y==5)) {
          hexagons.add(HexagonPaintDifferentDesign(computeCenter(y, x), radius, backgroundImage));
        } else {
          hexagons.add(HexagonPaintDifferentDesign(computeCenter(y, x), radius));
        }
      }
    }
  }

  static double computeRadius(double screenWidth, double screenHeight) {
    // var maxWidth = (screenWidth - totalMarginX()) / (((nrX - 1) * 1.5) + 2);
    // var maxHeight = 0.5 *
    //     (screenHeight - totalMarginY()) /
    //     (heightRatioOfRadius() * (nrY + 0.5));
    // return math.min(maxWidth, maxHeight);
    var maxWidth = (screenWidth) / (((nrX - 1) * 1.5) + 2);
    var maxHeight = 0.5 *
        (screenHeight) /
        (heightRatioOfRadius() * (nrY + 0.5));
    return math.min(maxWidth, maxHeight);

  }

  static double heightRatioOfRadius() =>
      math.cos(math.pi / HexagonPainterDifferentDesign.SIDES_OF_HEXAGON);

  static double totalMarginY() => (nrY - 0.5) * marginY;

  static int totalMarginX() => (nrX - 1) * marginX;

  static double computeHeight(double radius) {
    return heightRatioOfRadius() * radius * 2;
  }

  static double computeCornerLength(double radius) => radius / heightRatioOfRadius();

  Offset computeCenter(int y, int x) {
    // var centerX = computeX(x, y);
    var centerX = computeX(y, x);
    var centerY = computeY(y);
    return Offset(centerX, centerY);
  }

  computeY(int y) {
    // var centerY = y * (0.5 * cornerLength + radius ) + radius;
    var centerY = y * 1.5 * radius + radius;
    // double marginsVertical = computeEmptySpaceY() / 2;
    return centerY ;
  }

  double computeEmptySpaceY() {
    return screenHeight - ((nrY - 1) * height + 1.5 * height + totalMarginY());
  }


  double computeX(int y, int x) {
    var centerX;
    //double marginsHorizontal = computeEmptySpaceX() / 2;
    if(y % 2 == 0){
      centerX = 0.5 * height + x * height;
    }else{
      centerX = 0.5 * height + x * height + 0.5 * height;
    }
    return centerX ;
  }

  double computeEmptySpaceX() {
    return screenWidth -
        (totalMarginX() + (nrX - 1) * 1.5 * radius + 2 * radius);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(children: hexagons),
      ],
    );
  }
}
