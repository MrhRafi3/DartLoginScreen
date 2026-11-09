import 'dart:ui';
import 'package:oglet/data/timeline_data.dart';

class AnimationState {
  final double t;
  final double T;
  final BeatState beat;
  final double emailShakeX;
  final double phoneOpacity;
  final double buttonPressScale;
  final double spinnerAngle;
  final double titleBlur;
  final bool isTitleDone;
  final bool isSubtitleDone;
  final bool isSubtitleError;
  final bool tapActive;
  final Offset tapPosition;
  final double tapScale;
  final double tapOpacity;
  final double fadeOut;

  const AnimationState({
    required this.t,
    required this.T,
    required this.beat,
    required this.emailShakeX,
    required this.phoneOpacity,
    required this.buttonPressScale,
    required this.spinnerAngle,
    required this.titleBlur,
    required this.isTitleDone,
    required this.isSubtitleDone,
    required this.isSubtitleError,
    required this.tapActive,
    required this.tapPosition,
    required this.tapScale,
    required this.tapOpacity,
    required this.fadeOut,
  });

  factory AnimationState.initial() {
    return AnimationState(
      t: 0.0,
      T: 0.0,
      beat: TimelineData.calculateBeat(0.0),
      emailShakeX: 0.0,
      phoneOpacity: 0.0,
      buttonPressScale: 1.0,
      spinnerAngle: 0.0,
      titleBlur: 0.0,
      isTitleDone: false,
      isSubtitleDone: false,
      isSubtitleError: false,
      tapActive: false,
      tapPosition: Offset.zero,
      tapScale: 0.6,
      tapOpacity: 0.0,
      fadeOut: 1.0,
    );
  }
}
