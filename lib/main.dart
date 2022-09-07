import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:image/image.dart' as image;


void main()  {
  runApp(HexagonGridDemo());
}


Future<Shader> getUiImage(String imageAssetPath, int height, int width) async {
  final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
  image.Image? baseSizeImage = image.decodeImage(assetImageByteData.buffer.asUint8List());
  image.Image resizeImage = image.copyResize(baseSizeImage!, height: height, width: width);
  ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(image.encodePng(resizeImage)));
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  return getImageShader(frameInfo.image, height.toDouble(), width.toDouble());
}

Future<Shader> getImageShader (ui.Image image, double height, double width)  async {
  final completer = Completer<ImageInfo>();
  final ByteData? bytedata = await image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List headedIntList = Uint8List.view(bytedata!.buffer);

  // use the ResizeImage provider to resolve the image in the required size
  ResizeImage(MemoryImage(headedIntList), width: width.toInt(), height:  height.toInt())
      .resolve(ImageConfiguration(size: Size(width, height)))
      .addListener(ImageStreamListener((info, _) => completer.complete(info)));

  final info = await completer.future;
  return ImageShader(
    info.image,
    TileMode.mirror,
    TileMode.mirror,
    Float64List.fromList(Matrix4.identity().storage),
  );
}


class HexagonGridDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hexagon Grid Demo'),
        ),
        body: FutureBuilder(
          future: getUiImage('assets/images/islam.jpg', 100, 100),
          builder: (context, AsyncSnapshot<Shader> snapshot){
            return Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(8),
              child: LayoutBuilder(builder: (context, constraints) {
                return Container(
                  color: Colors.transparent,
                  child: HexagonGrid(constraints.maxWidth, constraints.maxHeight, snapshot.data),
                );
              }),
            );
          },
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
  final Shader? backgroundImage;

  final List<HexagonPaint> hexagons = [];

  HexagonGrid(this.screenWidth, this.screenHeight, this.backgroundImage)
      : radius = computeRadius(screenWidth, screenHeight),
        height = computeHeight(computeRadius(screenWidth, screenHeight)) {
    for (int x = 0; x < nrX; x++) {
      for (int y = 0; y < nrY; y++) {
        if((x==2 && y==4) || (x==4 && y==5)) {
          hexagons.add(HexagonPaint(computeCenter(x, y), radius, true, backgroundImage));
        } else {
          hexagons.add(HexagonPaint(computeCenter(x, y), radius, false, backgroundImage));
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
  final Shader? backgroundImage;

  HexagonPaint(this.center, this.radius, this.changeColor, this.backgroundImage);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HexagonPainter(center, radius, changeColor,this.backgroundImage),
    );
  }
}

class HexagonPainter extends CustomPainter {
  static const int SIDES_OF_HEXAGON = 6;
  final double radius;
  final Offset center;
  final bool changeColor;
  final Shader? backgroundImage;

  HexagonPainter(this.center, this.radius, this.changeColor, this.backgroundImage);

  @override
  void paint(Canvas canvas, Size size){
    Paint paint;
    paint = Paint()..color = Colors.blue;
    //var image = await getUiImage('assets/images/islam.jpg', 100, 100);
    Path path = createHexagonPath();

    if(changeColor) {
      if(backgroundImage != null){
        canvas.drawPath(path, Paint()
            ..shader = backgroundImage!,
        );
      }
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