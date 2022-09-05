import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui show Image ;
import 'package:http/http.dart' as http;
import 'package:quiver/cache.dart';

Future<void> main() async {
  var cache = MapCache<String, ui.Image>();
  var myUri = 'https://img.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg?t=st=1648470843~exp=1648471443~hmac=e627e64a2eec9d1abe3d9db23ecb082fc29cadb26da7ab313811130fb0bf4169&w=900';
  var img = await cache.get(myUri , ifAbsent: (uri){
    print('getting not cached image from $uri');
    return http.get(Uri.parse(uri)).then((resp) => decodeImageFromList(resp.bodyBytes));
  });
  runApp(HexagonGridDemo(img!));
}

class HexagonGridDemo extends StatelessWidget {
  final ui.Image myBackground;
  HexagonGridDemo(this.myBackground);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hexagon Grid Demo'),
        ),
        body: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(8),
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              color: Colors.transparent,
              child: HexagonGrid(constraints.maxWidth, constraints.maxHeight, myBackground),
            );
          }),
        ),
      ),
    );
  }
}

class HexagonGrid extends StatelessWidget {
  static const int nrX = 7;
  static const int nrY = 9;
  static const int marginY = 5;
  static const int marginX = 5;
  final double screenWidth;
  final double screenHeight;
  final double radius;
  final double height;
  final ui.Image myBackground;


  final List<HexagonPaint> hexagons = [];

  HexagonGrid(this.screenWidth, this.screenHeight,this.myBackground)
      : radius = computeRadius(screenWidth, screenHeight),
        height = computeHeight(computeRadius(screenWidth, screenHeight)) {
    for (int x = 0; x < nrX; x++) {
      for (int y = 0; y < nrY; y++) {
        if((x==2 && y==4) || (x==4 && y==5)) {
          hexagons.add(HexagonPaint(computeCenter(x, y), radius, true, myBackground));
        } else {
          hexagons.add(HexagonPaint(computeCenter(x, y), radius, false, myBackground));
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
    return Stack(children: hexagons);
  }
}

class HexagonPaint extends StatelessWidget {
  final Offset center;
  final double radius;
  final bool changeColor;
  final ui.Image myBackground;

  HexagonPaint(this.center, this.radius, this.changeColor, this.myBackground);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HexagonPainter(center, radius, changeColor, myBackground),
    );
  }
}

class HexagonPainter extends CustomPainter {
  static const int SIDES_OF_HEXAGON = 6;
  final double radius;
  final Offset center;
  final bool changeColor;
  final ui.Image myBackground;

  HexagonPainter(this.center, this.radius, this.changeColor, this.myBackground);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint;
    paint = Paint()..color = Colors.blue;

    Path path = createHexagonPath();
    if(changeColor) {
      canvas.drawImage(myBackground, center, paint);
    } else {
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