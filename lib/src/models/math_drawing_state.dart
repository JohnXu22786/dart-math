/// View mode for the math drawing page.
enum ViewMode {
  /// 2D function plotting (active, using JSXGraph).
  mode2D,

  /// 3D rendering (placeholder — coming soon).
  mode3D,
}

/// A single coordinate point (x, y).
class CoordinatePoint {
  final double x;
  final double y;

  const CoordinatePoint({required this.x, required this.y});

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory CoordinatePoint.fromJson(Map<String, dynamic> json) {
    return CoordinatePoint(
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() => '($x, $y)';
}

/// Viewport bounds for the 2D canvas.
class Viewport {
  final double xMin;
  final double yMin;
  final double xMax;
  final double yMax;

  const Viewport({
    required this.xMin,
    required this.yMin,
    required this.xMax,
    required this.yMax,
  });

  /// Default viewport: [-10, 10] × [-10, 10].
  factory Viewport.defaultViewport() =>
      const Viewport(xMin: -10, yMin: -10, xMax: 10, yMax: 10);

  Map<String, dynamic> toJson() => {
        'xMin': xMin,
        'yMin': yMin,
        'xMax': xMax,
        'yMax': yMax,
      };

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      xMin: (json['xMin'] as num?)?.toDouble() ?? -10.0,
      yMin: (json['yMin'] as num?)?.toDouble() ?? -10.0,
      xMax: (json['xMax'] as num?)?.toDouble() ?? 10.0,
      yMax: (json['yMax'] as num?)?.toDouble() ?? 10.0,
    );
  }

  @override
  String toString() => '[$xMin, $yMin, $xMax, $yMax]';
}

/// Message types sent from WebView to Flutter via the JavaScript channel.
enum WebViewMessageType {
  /// JSXGraph board is initialized and ready.
  ready,

  /// Coordinate data update from the plotted function.
  coordinateUpdate,

  /// Viewport changed (user panned/zoomed).
  viewportChange,

  /// Unknown message type.
  unknown,
}
