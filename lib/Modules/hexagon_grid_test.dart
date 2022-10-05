import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:hexcolor/hexcolor.dart';

import 'hexagon_custom_painter.dart';

class HexagonGridTest extends CustomPainter {
  // static const int nrX = 6;
  // static const int nrY = 12;
  final ui.Image? backgroundImage;
  HexagonGridTest(this.backgroundImage);

  @override
  void paint(Canvas canvas, Size size) {
    // 18 = 1/3 (size of the three hexagon) * 1/6 (number of the all radius 2+2+2)
    Offset top = Offset(size.width / 3, size.height - 40);
    Offset bottom = Offset(size.width / 3, size.height - 10);
    Offset center = Offset((top.dx + bottom.dx) / 2, (top.dy + bottom.dy) / 2);
    Offset radiusOffset = Offset(size.width / 3 + size.width /18, center.dy);
    double distanceBetweenRadiusAndCenter = (radiusOffset - center).distance;
    //Offset centerOfRigtLineRectangle = (size.width / 3, )
    double radius = (radiusOffset - top).distance;
    double height = computeHeight(radius);
    double length = cornerLength(radius);
    int nrX = size.width ~/ height;
    int nrY = size.height ~/ (radius + 10);
    // 18 = 1/3 (size of the three hexagon) * 1/6 (number of the all radius 2+2+2)
    // Offset top = Offset(size.width / 3, size.height - 40);
    // Offset bottom = Offset(size.width / 3, size.height - 10);
    // Offset center = Offset((top.dx + bottom.dx) / 2, (top.dy + bottom.dy) / 2);
    // Offset radiusOffset = Offset(size.width / 3 + size.width /18, center.dy);
    // double distanceBetweenRadiusAndCenter = (radiusOffset - center).distance;
    //
    // //Offset centerOfRigtLineRectangle = (size.width / 3, )
    // double radius = (radiusOffset - top).distance;
    //double radius = computeRadius(size.width, size.height);


    Offset firstOffset = Offset(0.5 * height, radius);

    Paint paint;
    paint = Paint()..color = HexColor('#E9EDEF');
    final hexagonBorderPaint = Paint()
      ..color = HexColor('#002744')
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    for(int j=0; j<nrY; j++){
      for(int i =0; i<nrX; i++){
        if(j % 2 == 0){
          Path path = createHexagonPath(Offset(firstOffset.dx + i * height, j * 1.5 * radius + firstOffset.dy), radius);
          canvas.drawPath(path, paint);
          canvas.drawPath(path, hexagonBorderPaint);
        }else{
          Path path = createHexagonPath(Offset(firstOffset.dx + i * height + 0.5 * height, j * 1.5 * radius  + firstOffset.dy), radius);
          canvas.drawPath(path, paint);
          canvas.drawPath(path, hexagonBorderPaint);
        }
      }
    }



    // double radius = size.width / 18;
    // center of the first hexagon
    // final hexagonBorderPaint = Paint()
    //   ..color = HexColor('#002744')
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1.0;
    // Path path1 = createHexagonPath(radiusOffset, radius);
    // // center of the second hexagon
    // Path path2 = createHexagonPath(Offset(radiusOffset.dx + 2 * distanceBetweenRadiusAndCenter, radiusOffset.dy), radius);
    // // center of the third hexagon
    // Path path3 = createHexagonPath(Offset(radiusOffset.dx + 4 * distanceBetweenRadiusAndCenter, radiusOffset.dy), radius);
    // Paint paint;
    // paint = Paint()..color = HexColor('#005284');
    //
    // // drawing the 3 hexagon at the center of size width
    // canvas.drawPath(path1, paint);
    // canvas.drawPath(path2, paint);
    // canvas.drawPath(path3, paint);

  }

  // static double computeRadius(double screenWidth, double screenHeight) {
  //   var maxWidth = (screenWidth) / (((nrX - 1) * 1.5) + 2);
  //   var maxHeight = 0.5 *
  //       (screenHeight) /
  //       (heightRatioOfRadius() * (nrY + 0.5));
  //   return math.max(maxWidth, maxHeight);
  // }

  // static double computeRadius(double screenWidth, double screenHeight) {
  //   var maxWidth = (screenWidth - totalMarginX()) / (((nrX - 1) * 1.5) + 2);
  //   var maxHeight = 0.5 *
  //       (screenHeight - totalMarginY()) /
  //       (heightRatioOfRadius() * (nrY + 0.5));
  //   return math.min(maxWidth, maxHeight);
  // }

  static double heightRatioOfRadius() =>
      math.cos(math.pi / HexagonPainter.SIDES_OF_HEXAGON);

  static double cornerLength(double radius) => radius / heightRatioOfRadius();


  static double computeHeight(double radius) {
    return heightRatioOfRadius() * radius * 2;
  }

  Path createHexagonPath(Offset center, double radius) {
    const int SIDES_OF_HEXAGON = 6;
    //const double radius = 25 ;
    //const Offset center = Offset(50, 50);
    final path = Path();
    var angle = (math.pi * 2) / SIDES_OF_HEXAGON;
    // Offset firstPoint = Offset(radius * math.cos(0.0), radius * math.sin(0.0));
    Offset firstPoint = Offset(radius * math.sin(0.0), radius * math.cos(0.0));
    path.moveTo(firstPoint.dx + center.dx, firstPoint.dy + center.dy);
    for (int i = 1; i <= SIDES_OF_HEXAGON; i++) {
      // double x = radius * math.cos(angle * i) + center.dx;
      // double y = radius * math.sin(angle * i) + center.dy;
      double x = radius * math.sin(angle * i) + center.dx;
      double y = radius * math.cos(angle * i) + center.dy;
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }



  @override
  bool shouldRepaint(HexagonGridTest oldDelegate) {
    return false;
  }
}