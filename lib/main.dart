import 'package:flutter/material.dart';

import 'Modules/hexagon_grid_demo_screen.dart';


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
