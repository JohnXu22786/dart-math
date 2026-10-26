import 'package:visual_math/visual_math.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DartMathExampleApp());
}

class DartMathExampleApp extends StatelessWidget {
  const DartMathExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dart-math',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const MathDrawingPage(),
    );
  }
}
