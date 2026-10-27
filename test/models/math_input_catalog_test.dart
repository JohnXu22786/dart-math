import 'package:flutter_test/flutter_test.dart';
import 'package:function_tree/src/defs.dart' as engine;
import 'package:visual_math/visual_math.dart';

void main() {
  test(
    'explicit logarithm shortcuts keep their bases and exponential grouping',
    () {
      final expected = <String, double>{
        'e': 2.718281828459045,
        'exp': 7.38905609893065,
        'ln': 0.6931471805599453,
        'log10': 0.3010299956639812,
        'log2': 1,
        'logbase': 1,
        'power': 4,
        'power2': 4,
        'power10': 100,
      };
      final shortcutNames = mathExponentialInputs
          .map((key) => key.name)
          .toSet();
      expect(
        shortcutNames.intersection({
          'reciprocal',
          'negativePower',
          'scientific',
        }),
        isEmpty,
      );
      for (final key in mathExponentialInputs) {
        final latex = key.latex
            .replaceAll('#0', '2')
            .replaceAll('#@', '2')
            .replaceAll('#?', '2');
        final formula = MathExpression.fromInput(latex);
        expect(formula.isValid, isTrue, reason: key.name);
        expect(formula.parameters, isEmpty, reason: key.name);
        expect(formula.evaluator(0), closeTo(expected[key.name]!, 1e-10));
      }
      expect(
        MathExpression.fromInput(r'\log_{10}\left(0\right)').samplePoints(),
        isEmpty,
      );
    },
  );
  test(
    'every evaluator function has a template with the same numeric meaning',
    () {
      expect(
        mathUnaryInputs.map((key) => key.name).toSet(),
        engine.oneParameterFunctionMap.keys.toSet(),
      );
      expect(
        mathBinaryInputs.map((key) => key.name).toSet(),
        engine.twoParameterFunctionMap.keys.toSet(),
      );
      for (final key in mathUnaryInputs) {
        final argument = key.name == 'fact' ? 4.0 : 0.5;
        final latex = key.latex
            .replaceAll('#0', '$argument')
            .replaceAll('#@', '$argument');
        final formula = MathExpression.fromInput(latex);
        expect(formula.isValid, isTrue, reason: '${key.name}: $latex');
        expect(
          formula.evaluator(0),
          closeTo(engine.oneParameterFunctionMap[key.name]!(argument), 1e-10),
          reason: key.name,
        );
      }
      for (final key in mathBinaryInputs) {
        final latex = key.latex
            .replaceAll('#0', '4')
            .replaceAll('#@', '4')
            .replaceAll('#?', '2');
        final formula = MathExpression.fromInput(latex);
        expect(formula.isValid, isTrue, reason: latex);
        final expected = key.name == 'pow'
            ? engine.twoParameterFunctionMap[key.name]!(4, 2)
            : engine.twoParameterFunctionMap[key.name]!(2, 4);
        expect(
          formula.evaluator(0),
          closeTo(expected, 1e-10),
          reason: key.name,
        );
      }
    },
  );

  test(
    'constant templates retain engine values instead of becoming parameters',
    () {
      expect(
        mathConstantInputs.map((key) => key.name).toSet(),
        engine.constantMap.keys
            .where((name) => name == name.toLowerCase())
            .toSet(),
      );
      for (final key in mathConstantInputs) {
        final formula = MathExpression.fromInput(key.latex);
        expect(formula.isValid, isTrue, reason: key.name);
        expect(formula.parameters, isEmpty, reason: key.name);
        expect(
          formula.evaluator(0),
          closeTo(engine.constantMap[key.name]!, 1e-10),
          reason: key.name,
        );
      }
    },
  );
}
