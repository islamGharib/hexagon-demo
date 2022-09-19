import 'package:flutter/cupertino.dart';
import 'package:hexagon_test/lib.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;




class HexagonGrid extends StatelessWidget {
  static const int nrX = 7;
  static const int nrY = 10;
  static const int marginY = 0;
  static const int marginX = 0;
  final double screenWidth;
  final double screenHeight;
  final double radius;
  final double height;
  final ui.Image? backgroundImage;

  final List<HexagonPaint> hexagons = [];

  HexagonGrid(this.screenWidth, this.screenHeight, [this.backgroundImage])
      : radius = computeRadius(screenWidth, screenHeight),
        height = computeHeight(computeRadius(screenWidth, screenHeight)) {
    for (int x = 0; x < nrX; x++) {
      for (int y = 0; y < nrY; y++) {
        if((x==2 && y==4) || (x==4 && y==5)) {
          hexagons.add(HexagonPaint(computeCenter(x, y), radius, backgroundImage));
        } else {
          hexagons.add(HexagonPaint(computeCenter(x, y), radius));
        }
      }
    }
  }

  static double computeRadius(double screenWidth, double screenHeight) {
    var maxWidth = (screenWidth - totalMarginX()) / (((nrX - 1) * 1.5) + 2);
    var maxHeight = 0.5 *
        (screenHeight - totalMarginY()) /
        (heightRatioOfRadius() * (nrY + 0.5));
    return math.min(maxWidth, maxHeight);
  }

  static double heightRatioOfRadius() =>
      math.cos(math.pi / HexagonPainter.SIDES_OF_HEXAGON);

  static double totalMarginY() => (nrY - 0.5) * marginY;

  static int totalMarginX() => (nrX - 1) * marginX;

  static double computeHeight(double radius) {
    return heightRatioOfRadius() * radius * 2;
  }

  Offset computeCenter(int x, int y) {
    var centerX = computeX(x);
    var centerY = computeY(x, y);
    return Offset(centerX, centerY);
  }

  computeY(int x, int y) {
    var centerY;
    if (x % 2 == 0) {
      centerY = y * height + y * marginY + height / 2;
    } else {
      centerY = y * height + (y + 0.5) * marginY + height;
    }
    double marginsVertical = computeEmptySpaceY() / 2;
    return centerY + marginsVertical;
  }

  double computeEmptySpaceY() {
    return screenHeight - ((nrY - 1) * height + 1.5 * height + totalMarginY());
  }

  double computeX(int x) {
    double marginsHorizontal = computeEmptySpaceX() / 2;
    return x * marginX + x * 1.5 * radius + radius + marginsHorizontal;
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