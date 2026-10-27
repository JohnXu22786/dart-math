import 'package:flutter_test/flutter_test.dart';
import 'package:visual_math/visual_math.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MathCanvasWebView - buildMathHtml', () {
    test('replaces EXPRESSION_PLACEHOLDER with JS expression', () {
      final html = MathCanvasWebView.buildMathHtml('Math.pow(x,2)');
      expect(html, contains('Math.pow(x,2)'));
      expect(html, isNot(contains('EXPRESSION_PLACEHOLDER')));
    });

    test('creates unique board ID', () {
      final html1 = MathCanvasWebView.buildMathHtml('x^2');
      final html2 = MathCanvasWebView.buildMathHtml('x^2');
      expect(html1, isNot(equals(html2)));
    });
  });
}
