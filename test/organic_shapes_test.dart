import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafi_login_template/src/core/geometry/organic_shapes.dart';
import 'package:rafi_login_template/src/data/crew_data.dart';

void main() {
  group('Organic Shapes Geometry Tests', () {
    test('Cookie body path is closed and within expected bounds', () {
      final Path path = OrganicShapes.cookieBody();
      final Rect bounds = path.getBounds();
      expect(bounds.width, closeTo(160.0, 30.0));
      expect(bounds.height, closeTo(160.0, 30.0));
      expect(bounds.center.dx, closeTo(0.0, 1.0));
      expect(bounds.center.dy, closeTo(0.0, 1.0));
    });

    test('Bean body path has 100x290 capsule dimensions', () {
      final Path path = OrganicShapes.beanBody();
      final Rect bounds = path.getBounds();
      expect(bounds.width, 100.0);
      expect(bounds.height, 290.0);
      expect(bounds.left, -50.0);
      expect(bounds.top, -145.0);
    });

    test('Sun body path has 120 samples geometry', () {
      final Path path = OrganicShapes.sunBody();
      final Rect bounds = path.getBounds();
      expect(bounds.width, greaterThan(80.0));
      expect(bounds.height, greaterThan(80.0));
    });

    test('Wobble and Pebble body paths have valid bounds', () {
      final Path wobble = OrganicShapes.wobbleBody();
      final Path pebble = OrganicShapes.pebbleBody();
      expect(wobble.getBounds().isEmpty, false);
      expect(pebble.getBounds().isEmpty, false);
    });

    test('Facial extras paths produce non-empty geometry', () {
      expect(OrganicShapes.sweatPath().getBounds().isEmpty, false);
      expect(OrganicShapes.heartPath().getBounds().isEmpty, false);
      expect(OrganicShapes.happyEyePath(20.0).getBounds().isEmpty, false);
      expect(OrganicShapes.browPath(20.0).getBounds().isEmpty, false);
      expect(OrganicShapes.starPath(8.0).getBounds().isEmpty, false);
    });

    test('CrewData initialises 5 members with 3 back and 2 front', () {
      expect(CrewData.crew.length, 5);
      expect(CrewData.backCrew.length, 3);
      expect(CrewData.frontCrew.length, 2);
    });
  });
}
