# visual_math

A Flutter package containing Stroom's 2D graphing and 3D geometry feature:
expression parsing and plotting, implicit contours, parameter controls, a
math keyboard and formula editor, 3D scene geometry and construction tools,
and interactive 2D/3D canvases.

Source code: <https://github.com/JohnXu22786/visual-math>.

Import `package:visual_math/visual_math.dart` for the public models, widgets, and
`MathDrawingPage`. The formula editor uses the included MathLive assets; the
2D JSXGraph canvas loads JSXGraph from its CDN when used.

## Run the standalone example

The package includes a thin Flutter host in `example/`. From the repository
root, run:

```sh
cd example
flutter pub get
flutter run -d chrome
```

The example depends on the package through the local `path: ..` dependency and
opens the same `MathDrawingPage` exported by the package.

## Embed in a Flutter app

Add `visual_math` from pub.dev in the consuming app's `pubspec.yaml`:

```yaml
dependencies:
  visual_math: ^0.1.0
```

Then import and show the page:

```dart
import 'package:visual_math/visual_math.dart';
import 'package:flutter/material.dart';

MaterialApp(
  home: const MathDrawingPage(),
)
```

Flutter includes the package's declared MathLive assets in the app asset bundle.
The package loads the editor page from its package asset namespace, so consumers
do not need to copy or redeclare those assets.

## License

GNU Affero General Public License v3.0 only (`AGPL-3.0-only`). See [LICENSE](LICENSE).

## Source attribution and history

The feature is adapted from [JohnXu22786/Stroom](https://github.com/JohnXu22786/Stroom),
available under the same license. See [NOTICE.md](NOTICE.md) for source
revisions and the history-transfer boundary. The vendored MathLive assets retain
their upstream license files.
