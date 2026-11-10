import 'package:flutter_test/flutter_test.dart';
import 'package:rafi_login_template/src/core/math/math_utils.dart';
import 'package:rafi_login_template/src/core/math/spring.dart';

void main() {
  group('MathUtils Tests', () {
    test('clamp correctly restricts values', () {
      expect(MathUtils.clamp(-0.5, 0.0, 1.0), 0.0);
      expect(MathUtils.clamp(1.5, 0.0, 1.0), 1.0);
      expect(MathUtils.clamp(0.42, 0.0, 1.0), 0.42);
    });

    test('lerp computes linear interpolation', () {
      expect(MathUtils.lerp(10.0, 20.0, 0.0), 10.0);
      expect(MathUtils.lerp(10.0, 20.0, 1.0), 20.0);
      expect(MathUtils.lerp(10.0, 20.0, 0.5), 15.0);
    });

    test('eio computes cubic ease-in-out', () {
      expect(MathUtils.eio(0.0), 0.0);
      expect(MathUtils.eio(1.0), 1.0);
      expect(MathUtils.eio(0.5), 0.5);
      expect(MathUtils.eio(0.25), lessThan(0.25));
      expect(MathUtils.eio(0.75), greaterThan(0.75));
    });

    test('seg smoothly eases progress over range', () {
      expect(MathUtils.seg(0.0, 1.0, 2.0), 0.0);
      expect(MathUtils.seg(3.0, 1.0, 2.0), 1.0);
      expect(MathUtils.seg(1.5, 1.0, 2.0), 0.5);
    });
  });

  group('Spring Physics Tests', () {
    test('semi-implicit Euler integration moves towards target', () {
      final spring = Spring(k: 140.0, c: 20.0);
      expect(spring.x, 0.0);
      expect(spring.v, 0.0);

      // Step towards 1.0
      const double dt = 1.0 / 60.0;
      for (int i = 0; i < 60; i++) {
        spring.step(1.0, dt);
      }

      // Should be close to target after 1 second
      expect(spring.x, closeTo(1.0, 0.05));
    });

    test('spring reset clears position and velocity', () {
      final spring = Spring(k: 260.0, c: 30.0);
      spring.step(1.0, 0.1);
      expect(spring.x, isNot(0.0));
      expect(spring.v, isNot(0.0));

      spring.reset();
      expect(spring.x, 0.0);
      expect(spring.v, 0.0);
    });
  });
}
