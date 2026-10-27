import 'package:flutter_test/flutter_test.dart';
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
      expect(mathUnaryInputs.map((key) => key.name).toSet(), {
        'abs',
        'acos',
        'asin',
        'atan',
        'ceil',
        'cos',
        'cosh',
        'cot',
        'coth',
        'csc',
        'csch',
        'exp',
        'fact',
        'floor',
        'ln',
        'log',
        'round',
        'sec',
        'sech',
        'sin',
        'sinh',
        'sqrt',
        'tan',
        'tanh',
      });
      expect(mathBinaryInputs.map((key) => key.name).toSet(), {
        'log',
        'nrt',
        'pow',
      });
      const expectedUnaryValues = <String, double>{
        'abs': 0.5,
        'acos': 1.0471975511965979,
        'asin': 0.5235987755982989,
        'atan': 0.4636476090008061,
        'ceil': 1,
        'cos': 0.8775825618903728,
        'cosh': 1.1276259652063807,
        'cot': 1.830487721712452,
        'coth': 2.163953413738653,
        'csc': 2.085829642933488,
        'csch': 1.9190347513349437,
        'exp': 1.6487212707001282,
        'fact': 24,
        'floor': 0,
        'ln': -0.6931471805599453,
        'log': -0.6931471805599453,
        'round': 1,
        'sec': 1.139493927324549,
        'sech': 0.886818883970074,
        'sin': 0.479425538604203,
        'sinh': 0.5210953054937474,
        'sqrt': 0.7071067811865476,
        'tan': 0.5463024898437905,
        'tanh': 0.46211715726000974,
      };
      for (final key in mathUnaryInputs) {
        final argument = key.name == 'fact' ? 4.0 : 0.5;
        final latex = key.latex
            .replaceAll('#0', '$argument')
            .replaceAll('#@', '$argument');
        final formula = MathExpression.fromInput(latex);
        expect(formula.isValid, isTrue, reason: '${key.name}: $latex');
        expect(
          formula.evaluator(0),
          closeTo(expectedUnaryValues[key.name]!, 1e-10),
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
        final expected = switch (key.name) {
          'log' || 'nrt' => 2.0,
          'pow' => 16.0,
          _ => throw StateError('Unexpected binary function ${key.name}'),
        };
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
      expect(mathConstantInputs.map((key) => key.name).toSet(), {
        'e',
        'pi',
        'ln2',
        'ln10',
        'log2e',
        'log10e',
        'sqrt2',
        'sqrt1_2',
      });
      const expectedValues = <String, double>{
        'e': 2.718281828459045,
        'pi': 3.141592653589793,
        'ln2': 0.6931471805599453,
        'ln10': 2.302585092994046,
        'log2e': 1.4426950408889634,
        'log10e': 0.4342944819032518,
        'sqrt2': 1.4142135623730951,
        'sqrt1_2': 0.7071067811865476,
      };
      for (final key in mathConstantInputs) {
        final formula = MathExpression.fromInput(key.latex);
        expect(formula.isValid, isTrue, reason: key.name);
        expect(formula.parameters, isEmpty, reason: key.name);
        expect(
          formula.evaluator(0),
          closeTo(expectedValues[key.name]!, 1e-10),
          reason: key.name,
        );
      }
    },
  );
}
