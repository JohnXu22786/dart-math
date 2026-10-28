import 'package:visual_math/visual_math.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const VisualMathExampleApp());
}

class VisualMathExampleApp extends StatelessWidget {
  const VisualMathExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'visual_math',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const MathDrawingPage(),
    );
  }
}
