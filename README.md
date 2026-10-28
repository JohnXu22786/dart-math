# visual_math

`visual_math` is a Flutter package for interactive 2D graphing and 3D geometry.
It includes expression models and parsing, formula editing, parameter controls,
a math keyboard, and reusable 2D and 3D canvases. The package's main screen is
`MathDrawingPage`.

Source: <https://github.com/JohnXu22786/visual-math>.

## Install

Add the package to your app's `pubspec.yaml`:

```yaml
dependencies:
  visual_math: ^0.1.0
```

Then resolve dependencies with `flutter pub get`. Import the public library:

```dart
import 'package:visual_math/visual_math.dart';
```

The package declares its MathLive editor and font assets in `pubspec.yaml`.
Flutter bundles them automatically; the consuming app does not need to copy or
redeclare them.

## Use the complete drawing screen

Place `MathDrawingPage` in your app to provide formula editing, plotting, and
the 3D geometry workspace. Its optional `initialExpression` seeds the formula
field.

```dart
import 'package:flutter/material.dart';
import 'package:visual_math/visual_math.dart';

void main() => runApp(const VisualMathApp());

class VisualMathApp extends StatelessWidget {
  const VisualMathApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: MathDrawingPage(initialExpression: 'x^2'),
      );
}
```

## Embed individual components

`MathCanvas` is a pure-Flutter 2D plot that can be embedded independently. It
accepts an optional initial expression and reports ready, viewport, coordinate,
and error events through callbacks.

```dart
MathCanvas(
  initialExpression: 'sin(x)',
  onError: (message) => debugPrint(message),
)
```

The library also exports `MathCanvas3D`, `MathFormulaField`, `MathKeyboard`,
`MathParameterControls`, `Math3DToolbar`, `MathCanvasWebView`, `FormulaEntry`,
the expression and geometry models, and the parser. These widgets expose their
current constructors and callbacks directly; see their API documentation for
the inputs each component requires. `MathCanvasWebView` is a separate
JSXGraph-backed canvas with network requirements described below; it is not the
canvas used by `MathDrawingPage`.

## Platform behavior

The example's release builds passed CI on Linux x64, Web, Android APK, Windows
x64, macOS x64 and ARM64, and unsigned iOS ARM64. These are build results; they
do not claim identical runtime behavior on each target.

| Target | Formula editor in `MathDrawingPage` | Main 2D and 3D canvases |
| --- | --- | --- |
| Android, iOS, macOS, Windows | MathLive editor in the platform WebView | Pure-Flutter canvases |
| Linux, Web | Built-in formula preview and source editing fallback; no embedded MathLive editor | Pure-Flutter canvases |

`MathFormulaField.supported` reports whether the embedded MathLive editor is
used. Linux and Web use `flutter_math_fork` for formula preview and source input
instead. That fallback does not provide MathLive's structured editing
interaction. The 2D `MathCanvas` and the 3D canvas are Flutter widgets and do
not depend on WebView.

Native MathLive support is provided by `flutter_inappwebview`. Use Flutter's
normal platform plugin setup when building the host app. The
`flutter_inappwebview` 6.1.5 documentation lists these platform prerequisites
for that release; the package's `^6.1.5` constraint can resolve later
compatible versions, so check the plugin's current setup guide as needed:

- Android: AndroidX, `minSdkVersion` 19 or later, `compileSdk` 34 or later, and
  Android Gradle Plugin 7.3.0 or later.
- iOS: iOS 12 or later and Xcode 15 or later.
- macOS: macOS 10.14 or later and Xcode 15 or later.
- Windows: NuGet CLI on `PATH` and the Microsoft Edge WebView2 Runtime
  installed on the target machine.

The exact build toolchain may require newer versions. See the
[`flutter_inappwebview` setup guide](https://inappwebview.dev/docs/intro/) for
current host-project setup details.

## MathLive assets and network access

The formula editor loads `editor.html`, JavaScript, styles, and fonts from the
package's bundled `assets/vendor/mathlive/` directory. The font directory is
resolved relative to that local editor page. Normal formula entry and preview
do not fetch MathLive or its fonts from a CDN, so this editor can work offline
after the Flutter app has installed its assets.

The main `MathCanvas` does not make network requests. The separately exported
`MathCanvasWebView` builds a JSXGraph page that fetches its JavaScript and CSS
from `https://cdn.jsdelivr.net`. That widget has no bundled JSXGraph copy or
offline fallback: the CDN must be reachable for its board to render. The
generated page includes inline JavaScript and styles, and the package does not
set a Content Security Policy. If the WebView configuration applies a CSP to
that page, allow `https://cdn.jsdelivr.net` for scripts and styles and permit
the page's inline script and style blocks. If network access is blocked, use
`MathCanvas`, which renders with Flutter instead.

## Standalone example

The repository includes a minimal Flutter host under `example/`. Run it from
the repository root with:

```sh
cd example
flutter pub get
flutter run -d chrome
```

The example uses the package through the local `path: ..` dependency and opens
`MathDrawingPage`. On Web, its formula editor uses the built-in fallback.

## License and attribution

This package is licensed under the GNU Affero General Public License v3.0 only
(`AGPL-3.0-only`). See [LICENSE](LICENSE). The feature is adapted from
[JohnXu22786/Stroom](https://github.com/JohnXu22786/Stroom), available under
the same license. See [NOTICE.md](NOTICE.md) for source revisions and the
history-transfer boundary. Vendored MathLive assets retain their upstream
license files.
