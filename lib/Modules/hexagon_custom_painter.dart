import 'package:flutter/cupertino.dart';
import 'package:hexagon_test/lib.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class HexagonPainter extends CustomPainter {
  static const int SIDES_OF_HEXAGON = 6;
  final double radius;
  final Offset center;
  final ui.Image? backgroundImage;

  HexagonPainter(this.center, this.radius, [this.backgroundImage]);

  @override
  void paint(Canvas canvas, Size size){
    Paint paint;
    paint = Paint()..color = HexColor('E9EDEF');
    //var image = await getUiImage('assets/images/islam.jpg', 100, 100);
    Path path = createHexagonPath();
    final borderPaint = Paint()
      ..color = HexColor('002744')
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);

    if(backgroundImage != null){
      // Paint paintCircle = Paint()..color = Colors.black;
      // canvas.drawCircle(center, radius-7, paint);

      // to fill image inside my path (Hexagon path)
      // width and height of the part of the image will display
      var drawImageWidth = 0.0;
      var drawImageHeight = -size.height*0.8;
      // adding a rectangle where my image will display inside it
      path.addOval(Rect.fromLTWH(drawImageWidth, drawImageHeight, backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble()));
      // clipping the rectangle to be the the as path shape(hexagon)
      canvas.clipPath(path);
      // draw my image inside the clipping hexagon
      canvas.drawImage(backgroundImage!, Offset(center.dx - backgroundImage!.width / 2, center.dy - backgroundImage!.height / 2), paint);
    }else{
      canvas.drawPath(path, paint);
    }

  }

  Path createHexagonPath() {
    final path = Path();
    var angle = (math.pi * 2) / SIDES_OF_HEXAGON;
    Offset firstPoint = Offset(radius * math.cos(0.0), radius * math.sin(0.0));
    path.moveTo(firstPoint.dx + center.dx, firstPoint.dy + center.dy);
    for (int i = 1; i <= SIDES_OF_HEXAGON; i++) {
      double x = radius * math.cos(angle * i) + center.dx;
      double y = radius * math.sin(angle * i) + center.dy;
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}