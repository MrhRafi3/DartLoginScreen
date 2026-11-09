import 'dart:ui';
import 'package:oglet/core/constants/animation_constants.dart';
import 'package:oglet/core/math/math_utils.dart';
import 'package:oglet/data/oglet_content.dart';

class TapEvent {
  final double time;
  final double x;
  final double y;

  const TapEvent(this.time, this.x, this.y);

  Offset get offset => Offset(x, y);
}

class BeatState {
  final int nameLength;
  final String email;
  final int passwordDots;
  final int focusedField; // 0: Name, 1: Email, 2: Password, -1: None
  final bool isError;
  final double errorOpacity;
  final bool isValid;
  final bool isLoading;
  final bool isDone;

  const BeatState({
    required this.nameLength,
    required this.email,
    required this.passwordDots,
    required this.focusedField,
    required this.isError,
    required this.errorOpacity,
    required this.isValid,
    required this.isLoading,
    required this.isDone,
  });

  String get displayedName => OgletContent.name.substring(0, nameLength);
}

abstract final class TimelineData {
  static const List<TapEvent> taps = [
    TapEvent(1.4, 200.0, 400.0), // Name field
    TapEvent(2.7, 200.0, 486.0), // Email field
    TapEvent(4.4, 200.0, 677.0), // "Create account"
    TapEvent(6.3, 300.0, 486.0), // Back to Email
    TapEvent(7.2, 200.0, 588.0), // Password field
    TapEvent(8.7, 200.0, 677.0), // "Create account" again
  ];

  static BeatState calculateBeat(double t) {
    // Letters of name typed: 1.6 to 2.3s
    final int n = (MathUtils.clamp((t - 1.6) / 0.7) * OgletContent.name.length)
        .floor();

    // Email typo: 2.9 to 4.0s
    final int e1 =
        (MathUtils.clamp((t - 2.9) / 1.1) * OgletContent.emailTypo.length)
            .floor();
    // Email fix: 6.5 to 6.9s
    final int e2 =
        (MathUtils.clamp((t - 6.5) / 0.4) * OgletContent.emailFix.length)
            .floor();
    final String e =
        OgletContent.emailTypo.substring(0, e1) +
        OgletContent.emailFix.substring(0, e2);

    // Password dots: 7.4 to 8.4s
    final int p =
        (MathUtils.clamp((t - 7.4) / 1.0) * OgletContent.passwordLength)
            .floor();

    // Focused field index
    final int focus = (t >= 1.4 && t < 2.7)
        ? 0
        : (t >= 2.7 && t < 4.4)
        ? 1
        : (t >= 6.3 && t < 7.2)
        ? 1
        : (t >= 7.2 && t < 8.7)
        ? 2
        : -1;

    final bool err =
        t >= AnimationConstants.atError && t < AnimationConstants.atErrorEnd;
    final double errK =
        MathUtils.clamp((t - AnimationConstants.atError) / 0.15) *
        (1.0 - MathUtils.clamp((t - 6.4) / 0.3));
    final bool valid = t >= AnimationConstants.atFixed;
    final bool load =
        t >= AnimationConstants.atLoading && t < AnimationConstants.atDone;
    final bool done =
        t >= AnimationConstants.atDone && t < AnimationConstants.atDoneEnd;

    return BeatState(
      nameLength: n,
      email: e,
      passwordDots: p,
      focusedField: focus,
      isError: err,
      errorOpacity: errK,
      isValid: valid,
      isLoading: load,
      isDone: done,
    );
  }
}
