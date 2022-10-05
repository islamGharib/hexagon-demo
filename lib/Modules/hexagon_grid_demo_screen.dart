
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;

import '../lib.dart';
import 'bottom_bar_custom_painter.dart';
import 'hexagon_different_grid_design/hexagon_grid.dart';
import 'hexagon_grid_test.dart';


class HexagonGridDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#E9EDEF'),
      appBar: AppBar(
        title: Text('Hexagon Grid Demo'),
      ),
      body: FutureBuilder(
        future: getUiImage('assets/images/islam.jpg', 100, 100),
        builder: (context, AsyncSnapshot<ui.Image> snapshot){
          return LayoutBuilder(builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    // child: Stack(
                    //     children: <Widget>[
                    //       Positioned(
                    //           bottom: 0.0,
                    //           left: 0.0,
                    //           right: 0.0,
                    //           top: 0.0,
                    //           child: CustomPaint(
                    //             painter: HexagonGridTest(snapshot.data),
                    //           )
                    //       ),
                    //     ]
                    // ),
                    child: HexagonGridDifferentDesign(constraints.maxWidth, constraints.maxHeight , snapshot.data),
                  ),
                ),
                FutureBuilder(
                  future: getUiImage('assets/images/crown.png', 20, 20),
                  builder: (context, AsyncSnapshot<ui.Image> snapshot){
                    return SizedBox(
                      height: 50,
                      child: Stack(
                          children: <Widget>[
                            Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                top: 0.0,
                                child: CustomPaint(
                                  painter: BottomBarCustomPainter(snapshot.data),
                                )
                            ),
                          ]
                      ),
                    );
                  }
                )
              ],
            );
          });
        },
      ),
    ) ;
  }
}

Future<ui.Image> getUiImage(String imageAssetPath, int height, int width) async {
  final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
  image.Image? baseSizeImage = image.decodeImage(assetImageByteData.buffer.asUint8List());
  image.Image resizeImage = image.copyResize(baseSizeImage!, height: height, width: width);
  ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(image.encodePng(resizeImage)));
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  //return getImageShader(frameInfo.image, height.toDouble(), width.toDouble());
  return frameInfo.image;
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
