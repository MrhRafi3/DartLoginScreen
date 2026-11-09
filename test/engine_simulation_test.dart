import 'package:flutter_test/flutter_test.dart';
import 'package:oglet/engine/oglet_animation_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Animation Engine Simulation Tests', () {
    test('Reduced motion simulates directly to 12s still frame', () {
      final engine = OgletAnimationEngine(prefersReducedMotion: true);
      expect(engine.state.beat.isDone, true);
      expect(engine.state.isTitleDone, true);
      expect(engine.state.isSubtitleDone, true);
      expect(engine.state.beat.displayedName, 'Mira');
      expect(engine.state.beat.email, 'mira@studio.io');
      expect(engine.state.beat.passwordDots, 9);
      expect(engine.state.phoneOpacity, greaterThan(0.99));

      // Crew should be in joyful state
      for (final rig in engine.rigs) {
        expect(rig.blushOpacity, greaterThan(0.5));
        for (final eye in rig.eyes) {
          expect(eye.happyOpacity, greaterThan(0.5));
        }
      }
      engine.dispose();
    });
  });
}
