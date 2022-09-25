import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexagon_test/lib.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class BottomBarCustomPainter extends CustomPainter {

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
    // double radius = size.width / 18;
    // center of the first hexagon
    final hexagonBorderPaint = Paint()
      ..color = HexColor('#002744')
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    Path path1 = createHexagonPath(radiusOffset, radius);
    // center of the second hexagon
    Path path2 = createHexagonPath(Offset(radiusOffset.dx + 2 * distanceBetweenRadiusAndCenter, radiusOffset.dy), radius);
    // center of the third hexagon
    Path path3 = createHexagonPath(Offset(radiusOffset.dx + 4 * distanceBetweenRadiusAndCenter, radiusOffset.dy), radius);
    Paint paint;
    paint = Paint()..color = HexColor('#005284');
    // drawing first rectangle from left to 1/3 of size width
    canvas.drawRect(
      Rect.fromLTRB(
          0.0, size.height - 40, size.width / 3, size.height - 10.0
      ),
      Paint()..color = HexColor('#003459'),
    );
    // drawing the 3 hexagon at the center of size width
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path2, hexagonBorderPaint);
    // drawing second rectangle from right to 1/3 of size width
    canvas.drawRect(
      Rect.fromLTRB(
          2 * size.width / 3, size.height - 40, size.width, size.height - 10.0
      ),
      Paint()..color = HexColor('#003459'),
    );
    canvas.drawPath(path3, paint);
    // adding an icon at the center of first hexagon
    const icon = Icons.menu;
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      fontFamily: icon.fontFamily,
    ))
      ..addText(String.fromCharCode(icon.codePoint));
    var para = builder.build();
    para.layout(ui.ParagraphConstraints(width: radius));
    canvas.drawParagraph(para, Offset(size.width / 3 + distanceBetweenRadiusAndCenter - para.width / 4, radiusOffset.dy - para.height / 2));

    // drawing 2 internal hexagon at the middle hexagon
    double internalHexagonRadius = radius / 4;
    Path firstInternalHexagonPath = createHexagonPath(Offset((center.dx + 3 * distanceBetweenRadiusAndCenter) - distanceBetweenRadiusAndCenter / 2, radiusOffset.dy), internalHexagonRadius);
    Path secondInternalHexagonPath = createHexagonPath(Offset((center.dx + 3 * distanceBetweenRadiusAndCenter) + distanceBetweenRadiusAndCenter / 2, radiusOffset.dy), internalHexagonRadius);
    final internalHexagonBorderPaint = Paint()
      ..color = HexColor('#C7D0D5')
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    Paint internalHexagonPaint = Paint()..color = HexColor('#F3F4F6');
    canvas.drawPath(firstInternalHexagonPath, internalHexagonPaint);
    canvas.drawPath(firstInternalHexagonPath, internalHexagonBorderPaint);
    canvas.drawPath(secondInternalHexagonPath, internalHexagonPaint);
    canvas.drawPath(secondInternalHexagonPath, internalHexagonBorderPaint);

    // display vs word between the 2 internal hexagon
    TextSpan span = TextSpan(
        style: TextStyle(
            color: HexColor('#C7D0D5'),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: internalHexagonRadius,
          //height: 19.36
        ),
        text: 'vs'
    );
    TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center
    );
    tp.layout();
    tp.paint(canvas, Offset(center.dx + 3 * distanceBetweenRadiusAndCenter - tp.width / 2, radiusOffset.dy - tp.height / 2));

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
  bool shouldRepaint(BottomBarCustomPainter oldDelegate) {
    return false;
  }
}