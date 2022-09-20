import 'package:flutter/material.dart';
import 'package:hexagon_test/lib.dart';


void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HexagonGridDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}
