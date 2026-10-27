import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visual_math/visual_math.dart';

void main() {
  testWidgets(
    'math input row keeps the regular source height for a tall rendered formula',
    (tester) async {
      final source = TextEditingController(text: r'\frac{x}{2}');
      final key = GlobalKey<MathFormulaFieldState>();
      Widget app(bool mathematical) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: MathFormulaField(
              key: key,
              controller: source,
              showWebView: false,
              mathematical: mathematical,
              onModeChanged: (_) {},
              onActivate: () {},
              onChanged: () {},
              onSubmitted: () {},
              label: '公式 1',
            ),
          ),
        ),
      );

      await tester.pumpWidget(app(false));
      final sourceHeight = tester.getSize(find.byKey(key)).height;
      await tester.pumpWidget(app(true));
      key.currentState!.acceptSnapshot({
        'revision': key.currentState!.revision,
        'height': 132,
        'type': 'selection',
      });
      await tester.pump();

      expect(
        tester.getSize(find.byKey(key)).height,
        closeTo(sourceHeight, 0.01),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      source.dispose();
    },
  );

  testWidgets(
    'theme changes recolor the retained native editor without reimport',
    (tester) async {
      final originalPlatform = InAppWebViewPlatform.instance;
      final platform = _EditorPlatform();
      InAppWebViewPlatform.instance = platform;
      addTearDown(
        () => InAppWebViewPlatform.instance =
            originalPlatform ?? _EditorPlatform(),
      );
      final source = TextEditingController(text: r'\frac{x}{2}');
      final key = GlobalKey<MathFormulaFieldState>();
      final light = ColorScheme.fromSeed(seedColor: Colors.blue);
      final dark = ColorScheme.fromSeed(
        seedColor: Colors.red,
        brightness: Brightness.dark,
      );
      Widget app(ColorScheme colors) => MaterialApp(
        theme: ThemeData(colorScheme: colors),
        home: Scaffold(
          body: MathFormulaField(
            key: key,
            controller: source,
            mathematical: true,
            onModeChanged: (_) {},
            onActivate: () {},
            onChanged: () {},
            onSubmitted: () {},
            label: '公式 1',
          ),
        ),
      );
      await tester.pumpWidget(app(light));
      final native = platform.editor!;
      final controller = native.controllerFromPlatform<InAppWebViewController>(
        native.controller,
      );
      native.params.onWebViewCreated!(controller);
      native.params.onLoadStop!(controller, null);
      await tester.pumpAndSettle();
      final state = key.currentState;
      final element = tester.element(find.byType(InAppWebView));
      expect(native.controller.scripts.last, contains(_css(light.onSurface)));
      await tester.pumpWidget(app(dark));
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(InAppWebView)), same(element));
      expect(key.currentState, same(state));
      expect(native.controller.scripts.last, contains(_css(dark.onSurface)));
      expect(native.controller.scripts.last, contains(_css(dark.primary)));
      expect(
        native.controller.scripts.where((s) => s.contains('setSource')),
        hasLength(1),
      );
      expect(source.text, r'\frac{x}{2}');
      await tester.pumpWidget(const SizedBox.shrink());
      source.dispose();
    },
  );

  testWidgets('switching modes keeps draft and rendered editor identity', (
    tester,
  ) async {
    final source = TextEditingController(text: r'y=\frac{x^{2}+1}{2}');
    final editorKey = GlobalKey<MathFormulaFieldState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MathFormulaField(
            key: editorKey,
            controller: source,
            showWebView: false,
            mathematical: true,
            onModeChanged: (_) {},
            onActivate: () {},
            onChanged: () {},
            onSubmitted: () {},
            label: '公式 1',
          ),
        ),
      ),
    );
    final state = editorKey.currentState;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MathFormulaField(
            key: editorKey,
            controller: source,
            showWebView: false,
            mathematical: false,
            onModeChanged: (_) {},
            onActivate: () {},
            onChanged: () {},
            onSubmitted: () {},
            label: '公式 1',
          ),
        ),
      ),
    );
    expect(source.text, r'y=\frac{x^{2}+1}{2}');
    expect(editorKey.currentState, same(state));
    await tester.enterText(find.byType(TextField), r'\sqrt{x+1}');
    expect(source.text, r'\sqrt{x+1}');
    await tester.pumpWidget(const SizedBox.shrink());
    source.dispose();
  });

  testWidgets('late rendered messages cannot overwrite a new source draft', (
    tester,
  ) async {
    final source = TextEditingController(text: 'x');
    final key = GlobalKey<MathFormulaFieldState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MathFormulaField(
            key: key,
            controller: source,
            showWebView: false,
            mathematical: true,
            onModeChanged: (_) {},
            onActivate: () {},
            onChanged: () {},
            onSubmitted: () {},
            label: '公式 1',
          ),
        ),
      ),
    );
    final oldRevision = key.currentState!.revision;
    source.text = 'x+1';
    key.currentState!.acceptSnapshot({'revision': oldRevision, 'latex': 'x+2'});
    expect(source.text, 'x+1');
    key.currentState!.acceptSnapshot({
      'revision': key.currentState!.revision,
      'latex': r'\frac{x}{2}',
      'edited': true,
      'sequence': 2,
    });
    expect(source.text, r'\frac{x}{2}');
    key.currentState!.acceptSnapshot({
      'revision': key.currentState!.revision,
      'latex': 'old',
      'edited': true,
      'sequence': 1,
    });
    expect(source.text, r'\frac{x}{2}');
    await tester.pumpWidget(const SizedBox.shrink());
    source.dispose();
  });
}

String _css(Color color) =>
    '#${color.toARGB32().toRadixString(16).substring(2)}';

class _EditorPlatform extends InAppWebViewPlatform {
  _NativeEditor? editor;

  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) => editor = _NativeEditor(params);
}

class _NativeEditor extends PlatformInAppWebViewWidget {
  final controller = _EditorController();
  _NativeEditor(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox();

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) =>
      params.controllerFromPlatform!(controller) as T;

  @override
  void dispose() {}
}

class _EditorController extends PlatformInAppWebViewController {
  final scripts = <String>[];
  _EditorController()
    : super.implementation(
        const PlatformInAppWebViewControllerCreationParams(id: 0),
      );

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    scripts.add(source);
    return null;
  }

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {}

  @override
  void dispose({bool isKeepAlive = false}) {}
}
