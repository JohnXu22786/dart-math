import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:visual_math/visual_math.dart';

void main() {
  test(
    'line clipping distinguishes extents and respects projection depth rules',
    () {
      const camera = Camera3D(theta: math.pi / 2, phi: 0, distance: 10);
      for (final projection in [
        Projection3D.parallel(scale: 6),
        Projection3D.perspective(),
      ]) {
        const a = Point3D(0, 0, 0);
        const b = Point3D(0, 1, 0);
        final segment = clipLineToView(
          const Object3D.line(a, b),
          camera,
          projection,
        );
        expect(segment, [a, b]);
        final ray = clipLineToView(
          const Object3D.line(a, b, lineKind: Line3DKind.ray),
          camera,
          projection,
        );
        expect(ray.first, a);
        expect(ray.last.y, greaterThan(1));
        final line = clipLineToView(
          const Object3D.line(a, b, lineKind: Line3DKind.line),
          camera,
          projection,
        );
        expect(line.first.y, lessThan(0));
        expect(line.last.y, greaterThan(1));
        final towardsEye = clipLineToView(
          const Object3D.line(a, Point3D(20, 0, 0)),
          camera,
          projection,
        );
        final behind = clipLineToView(
          const Object3D.line(Point3D(11, 0, 0), Point3D(20, 0, 0)),
          camera,
          projection,
        );
        if (projection.type == ProjectionType.perspective) {
          expect(towardsEye.last.x, closeTo(10 - projection.near, 1e-7));
          expect(behind, isEmpty);
        } else {
          expect(towardsEye.last.x, 20);
          expect(behind, [const Point3D(11, 0, 0), const Point3D(20, 0, 0)]);
        }
      }
    },
  );

  test('two-point tools keep their geometry and reject zero-length input', () {
    for (final tool in [
      ConstructionTool.segment,
      ConstructionTool.ray,
      ConstructionTool.vector,
      ConstructionTool.midpoint,
    ]) {
      final state = ConstructionState(tool: tool);
      const a = Point3D(1, 2, 3);
      const b = Point3D(4, 6, 8);
      state.addPoint(a);
      expect(state.addPoint(a), ConstructionAction.awaitInput);
      expect(state.addPoint(b), ConstructionAction.complete);
      final object = state.result!;
      switch (tool) {
        case ConstructionTool.midpoint:
          expect(object.point, a.midpoint(b));
        case ConstructionTool.vector:
          expect(object.point, a);
          expect(object.vector, b - a);
        default:
          expect(object.pointA, a);
          expect(object.pointB, b);
          expect(
            object.lineKind,
            tool == ConstructionTool.ray ? Line3DKind.ray : Line3DKind.segment,
          );
      }
    }
  });

  test(
    'three-point circle rejects collinearity and lies in the input plane',
    () {
      final state = ConstructionState(tool: ConstructionTool.circleThreePoints);
      const a = Point3D(1, 2, 0);
      const b = Point3D(1, 0, 2);
      const c = Point3D(1, -2, 0);
      state.addPoint(a);
      state.addPoint(b);
      expect(
        state.addPoint(const Point3D(1, -2, 4)),
        ConstructionAction.awaitInput,
      );
      expect(state.points, [a, b]);
      expect(state.addPoint(c), ConstructionAction.complete);
      for (final p in state.result!.vertices) {
        expect(p.x, closeTo(1, 1e-8));
        expect(p.distanceTo(const Point3D(1, 0, 0)), closeTo(2, 1e-8));
      }
      expect(state.result!.vertices.first.distanceTo(a), lessThan(1e-8));
      expect(state.result!.vertices.last.distanceTo(a), lessThan(1e-8));
    },
  );

  test(
    'regular polygon has equal sides in a tilted plane and validates count',
    () {
      expect(
        () => ConstructionState(
          tool: ConstructionTool.regularPolygon,
          polygonSides: 2,
        ),
        throwsArgumentError,
      );
      for (final count in [3, 6, 12]) {
        final state = ConstructionState(
          tool: ConstructionTool.regularPolygon,
          polygonSides: count,
        );
        state.addPoint(
          const Point3D(2, 0, 0),
          workingPlaneNormal: Vector3D.unitX,
        );
        state.addPoint(
          const Point3D(2, 3, 0),
          workingPlaneNormal: Vector3D.unitX,
        );
        final vertices = state.result!.vertices;
        expect(vertices, hasLength(count));
        for (var i = 0; i < count; i++) {
          expect(vertices[i].x, closeTo(2, 1e-8));
          expect(
            vertices[i].distanceTo(vertices[(i + 1) % count]),
            closeTo(3, 1e-8),
          );
        }
      }
    },
  );

  test(
    'regular tetrahedron has six equal edges including a vertical base edge',
    () {
      for (final b in [const Point3D(2, 0, 0), const Point3D(0, 0, 2)]) {
        final state = ConstructionState(tool: ConstructionTool.tetrahedron);
        state.addPoint(Point3D.origin);
        expect(state.addPoint(Point3D.origin), ConstructionAction.awaitInput);
        state.addPoint(b);
        final vertices = state.result!.vertices;
        expect(vertices, hasLength(4));
        expect(state.result!.indices, hasLength(12));
        for (var i = 0; i < 4; i++) {
          for (var j = i + 1; j < 4; j++) {
            expect(vertices[i].distanceTo(vertices[j]), closeTo(2, 1e-8));
          }
        }
        final volume =
            (vertices[1] - vertices[0])
                .cross(vertices[2] - vertices[0])
                .dot(vertices[3] - vertices[0])
                .abs() /
            6;
        expect(volume, closeTo(8 / (6 * math.sqrt(2)), 1e-8));
      }
    },
  );
}
