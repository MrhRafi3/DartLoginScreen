import 'package:flutter_test/flutter_test.dart';
import 'package:oglet/data/oglet_content.dart';
import 'package:oglet/data/timeline_data.dart';

void main() {
  group('Timeline & Beat Calculation Tests', () {
    test('initial state at t=0 has empty fields and resting state', () {
      final BeatState b0 = TimelineData.calculateBeat(0.0);
      expect(b0.nameLength, 0);
      expect(b0.email, '');
      expect(b0.passwordDots, 0);
      expect(b0.focusedField, -1);
      expect(b0.isError, false);
      expect(b0.isValid, false);
      expect(b0.isLoading, false);
      expect(b0.isDone, false);
    });

    test('name typing finishes by 2.4s', () {
      final BeatState bName = TimelineData.calculateBeat(2.4);
      expect(bName.displayedName, OgletContent.name);
      expect(bName.nameLength, 4);
    });

    test('email typo typed and error triggered at 4.55s', () {
      final BeatState bPreErr = TimelineData.calculateBeat(4.0);
      expect(bPreErr.email, OgletContent.emailTypo);
      expect(bPreErr.isError, false);

      final BeatState bErr = TimelineData.calculateBeat(4.55);
      expect(bErr.isError, true);

      final BeatState bErrFade = TimelineData.calculateBeat(4.65);
      expect(bErrFade.isError, true);
      expect(bErrFade.errorOpacity, greaterThan(0.0));
    });

    test('email fix ".io" typed and valid by 6.9s', () {
      final BeatState bFix = TimelineData.calculateBeat(6.9);
      expect(bFix.email, '${OgletContent.emailTypo}${OgletContent.emailFix}');
      expect(bFix.isValid, true);
      expect(bFix.isError, false);
    });

    test('password dots reach 9 between 7.4s and 8.4s', () {
      final BeatState bPass = TimelineData.calculateBeat(8.4);
      expect(bPass.passwordDots, 9);
    });

    test('loading state between 8.85s and 9.8s', () {
      final BeatState bLoad = TimelineData.calculateBeat(9.0);
      expect(bLoad.isLoading, true);
      expect(bLoad.isDone, false);
    });

    test('done state at 9.8s onwards', () {
      final BeatState bDone = TimelineData.calculateBeat(9.8);
      expect(bDone.isDone, true);
      expect(bDone.isLoading, false);
    });
  });
}
