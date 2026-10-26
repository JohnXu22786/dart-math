/// Structured inputs for the finite numeric vocabulary of the 2D evaluator.
/// Keeping these shared prevents a graph function from losing its keyboard path.
class MathInputTemplate {
  final String name, label, latex;
  const MathInputTemplate(this.name, this.label, this.latex);
}

const mathUnaryInputs = <MathInputTemplate>[
  MathInputTemplate('sin', r'\sin', r'\sin\left(#0\right)'),
  MathInputTemplate('cos', r'\cos', r'\cos\left(#0\right)'),
  MathInputTemplate('tan', r'\tan', r'\tan\left(#0\right)'),
  MathInputTemplate('asin', r'\operatorname{asin}', r'\arcsin\left(#0\right)'),
  MathInputTemplate('acos', r'\operatorname{acos}', r'\arccos\left(#0\right)'),
  MathInputTemplate('atan', r'\operatorname{atan}', r'\arctan\left(#0\right)'),
  MathInputTemplate('cot', r'\cot', r'\cot\left(#0\right)'),
  MathInputTemplate('sec', r'\sec', r'\sec\left(#0\right)'),
  MathInputTemplate('csc', r'\csc', r'\csc\left(#0\right)'),
  MathInputTemplate('sinh', r'\sinh', r'\sinh\left(#0\right)'),
  MathInputTemplate('cosh', r'\cosh', r'\cosh\left(#0\right)'),
  MathInputTemplate('tanh', r'\tanh', r'\tanh\left(#0\right)'),
  MathInputTemplate('coth', r'\coth', r'\coth\left(#0\right)'),
  MathInputTemplate(
      'sech', r'\operatorname{sech}', r'\operatorname{sech}\left(#0\right)'),
  MathInputTemplate(
      'csch', r'\operatorname{csch}', r'\operatorname{csch}\left(#0\right)'),
  MathInputTemplate('ln', r'\ln', r'\ln\left(#0\right)'),
  MathInputTemplate('log', r'\log', r'\log\left(#0\right)'),
  MathInputTemplate('exp', r'e^x', r'e^{#0}'),
  MathInputTemplate('sqrt', r'\sqrt{x}', r'\sqrt{#0}'),
  MathInputTemplate('abs', r'\left|x\right|', r'\left|#0\right|'),
  MathInputTemplate(
      'floor', r'\lfloor x\rfloor', r'\left\lfloor#0\right\rfloor'),
  MathInputTemplate('ceil', r'\lceil x\rceil', r'\left\lceil#0\right\rceil'),
  MathInputTemplate(
      'round', r'\operatorname{round}', r'\operatorname{round}\left(#0\right)'),
  MathInputTemplate('fact', r'n!', r'\left(#@\right)!'),
];

const mathBinaryInputs = <MathInputTemplate>[
  MathInputTemplate('log', r'\log_a x', r'\log_{#?}\left(#0\right)'),
  MathInputTemplate('nrt', r'\sqrt[n]{x}', r'\sqrt[#?]{#0}'),
  MathInputTemplate('pow', r'x^n', r'#@^{#?}'),
];

const mathConstantInputs = <MathInputTemplate>[
  MathInputTemplate('pi', r'\pi', r'\pi'),
  MathInputTemplate('e', 'e', 'e'),
  MathInputTemplate('ln2', r'\ln2', r'\ln\left(2\right)'),
  MathInputTemplate('ln10', r'\ln10', r'\ln\left(10\right)'),
  MathInputTemplate('log2e', r'\log_2e', r'\log_{2}\left(e\right)'),
  MathInputTemplate('log10e', r'\log_{10}e', r'\log_{10}\left(e\right)'),
  MathInputTemplate('sqrt2', r'\sqrt{2}', r'\sqrt{2}'),
  MathInputTemplate('sqrt1_2', r'\frac{1}{\sqrt{2}}', r'\frac{1}{\sqrt{2}}'),
];

/// Explicit bases avoid confusing the evaluator's legacy natural `log(x)`
/// with the common school notation for a base-ten logarithm.
const mathExponentialInputs = <MathInputTemplate>[
  MathInputTemplate('e', 'e', 'e'),
  MathInputTemplate('exp', r'e^x', r'e^{#0}'),
  MathInputTemplate('ln', r'\ln x', r'\ln\left(#0\right)'),
  MathInputTemplate('log10', r'\log_{10}x', r'\log_{10}\left(#0\right)'),
  MathInputTemplate('log2', r'\log_2x', r'\log_{2}\left(#0\right)'),
  MathInputTemplate('logbase', r'\log_ax', r'\log_{#?}\left(#0\right)'),
  MathInputTemplate('power', r'x^a', r'#@^{#?}'),
  MathInputTemplate('power2', r'2^x', r'2^{#0}'),
  MathInputTemplate('power10', r'10^x', r'10^{#0}'),
];

const mathGreekLowerNames = [
  'alpha',
  'beta',
  'gamma',
  'delta',
  'epsilon',
  'zeta',
  'eta',
  'theta',
  'iota',
  'kappa',
  'lambda',
  'mu',
  'nu',
  'xi',
  'omicron',
  'pi',
  'rho',
  'sigma',
  'tau',
  'upsilon',
  'phi',
  'chi',
  'psi',
  'omega',
];

const mathGreekUpperNames = [
  'Alpha',
  'Beta',
  'Gamma',
  'Delta',
  'Epsilon',
  'Zeta',
  'Eta',
  'Theta',
  'Iota',
  'Kappa',
  'Lambda',
  'Mu',
  'Nu',
  'Xi',
  'Omicron',
  'Pi',
  'Rho',
  'Sigma',
  'Tau',
  'Upsilon',
  'Phi',
  'Chi',
  'Psi',
  'Omega',
];

const mathGreekVariantNames = [
  'varepsilon',
  'vartheta',
  'varphi',
  'varpi',
  'varrho',
  'varsigma',
  'varkappa',
  'digamma',
];

const mathGreekNames = [
  ...mathGreekLowerNames,
  ...mathGreekUpperNames,
  ...mathGreekVariantNames,
];
