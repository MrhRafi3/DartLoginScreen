import 'package:flutter_test/flutter_test.dart';
import 'package:oglet/engine/oglet_animation_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Animation Engine Simulation Tests', () {
    test(
      'Reduced motion settles cleanly to steady frame and reacts to events',
      () {
        final engine = OgletAnimationEngine(prefersReducedMotion: true);

        // Verify clean initial idle state without automatic demo typing
        expect(engine.state.phoneOpacity, greaterThan(0.99));
        expect(engine.state.isError, false);
        expect(engine.state.isSuccess, false);
        expect(engine.state.beat.displayedName, '');
        expect(engine.state.beat.email, '');
        expect(engine.state.beat.passwordDots, 0);

        // Triggering success immediately puts crew into celebration
        engine.triggerSuccess();
        expect(engine.state.beat.isDone, true);
        expect(engine.state.isTitleDone, true);
        expect(engine.state.isSubtitleDone, true);

        // Crew should be in joyful celebration state
        for (final rig in engine.rigs) {
          expect(rig.blushOpacity, greaterThan(0.5));
          for (final eye in rig.eyes) {
            expect(eye.happyOpacity, greaterThan(0.5));
          }
        }
        engine.dispose();
      },
    );

    test('Engine responds to error and valid triggers', () {
      final engine = OgletAnimationEngine(prefersReducedMotion: true);

      engine.triggerError();
      expect(engine.state.isError, true);
      expect(engine.state.isSuccess, false);

      engine.clearError();
      expect(engine.state.isError, false);

      engine.setValid(true);
      expect(engine.state.isValid, true);

      engine.reset();
      expect(engine.state.isError, false);
      expect(engine.state.isSuccess, false);
      expect(engine.state.isValid, false);

      engine.dispose();
    });
  });
}
