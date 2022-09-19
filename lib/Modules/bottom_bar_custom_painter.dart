import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexagon_test/lib.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class BottomBarCustomPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    // 18 = 1/3 (size of the three hexagon) * 1/6 (number of the all radius 2+2+2)
    double radius = size.width / 18 ;
    // center of the first hexagon
    Path path1 = createHexagonPath(Offset(size.width / 3 + radius, size.height - 25.0), radius);
    // center of the second hexagon
    Path path2 = createHexagonPath(Offset(size.width / 3 + 3 * radius, size.height - 25.0), radius);
    // center of the third hexagon
    Path path3 = createHexagonPath(Offset(size.width / 3 + 5 * radius, size.height - 25.0), radius);
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
    canvas.drawPath(path3, paint);
    // drawing second rectangle from right to 1/3 of size width
    canvas.drawRect(
      Rect.fromLTRB(
          2 * size.width / 3, size.height - 40, size.width, size.height - 10.0
      ),
      Paint()..color = HexColor('#003459'),
    );
    // adding an icon at the center of first hexagon
    const icon = Icons.menu;
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      fontFamily: icon.fontFamily,
    ))
      ..addText(String.fromCharCode(icon.codePoint));
    var para = builder.build();
    para.layout(ui.ParagraphConstraints(width: radius));
    canvas.drawParagraph(para, Offset(size.width / 3 + radius - para.width / 3, size.height - 25.0 - para.height / 2));

    // drawing 2 internal hexagon at the middle hexagon
    double internalHexagonRadius = radius / 6;
    Path firstInternalHexagonPath = createHexagonPath(Offset((size.width / 3 + 3 * radius) - radius / 2, size.height - 25.0), internalHexagonRadius);
    Path secondInternalHexagonPath = createHexagonPath(Offset((size.width / 3 + 3 * radius) + radius / 2, size.height - 25.0), internalHexagonRadius);
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
          fontSize: 13,
          //height: 19.36
        ),
        text: 'vs'
    );
    TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left
    );
    tp.layout();
    tp.paint(canvas, Offset(size.width / 3 + 3 * radius - radius / 3, size.height - 25.0 - radius / 2));


  }

  Path createHexagonPath(Offset center, double radius) {
    const int SIDES_OF_HEXAGON = 6;
    //const double radius = 25 ;
    //const Offset center = Offset(50, 50);
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
  bool shouldRepaint(BottomBarCustomPainter oldDelegate) {
    return false;
  }
}