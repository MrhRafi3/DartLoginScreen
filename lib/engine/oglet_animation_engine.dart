import 'dart:math' as math;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'package:oglet/core/constants/animation_constants.dart';
import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/core/geometry/organic_shapes.dart';
import 'package:oglet/core/math/math_utils.dart';
import 'package:oglet/core/math/spring.dart';
import 'package:oglet/data/crew_data.dart';
import 'package:oglet/data/oglet_content.dart';
import 'package:oglet/data/timeline_data.dart';
import 'package:oglet/engine/animation_state.dart';
import 'package:oglet/engine/character_rig.dart';

class StarRenderState {
  final StarDefinition definition;
  double scale = 1.0;
  double rotation = 0.0; // in radians

  StarRenderState(this.definition);
}

class OgletAnimationEngine with ChangeNotifier {
  Ticker? _ticker;
  double? _startTime;
  double? _lastTime;
  double? _prevLoopTime;

  Offset _look = const Offset(200.0, 420.0);

  final Spring _worry = Spring(
    k: AnimationConstants.springWorry.$1,
    c: AnimationConstants.springWorry.$2,
  );
  final Spring _joy = Spring(
    k: AnimationConstants.springJoy.$1,
    c: AnimationConstants.springJoy.$2,
  );
  final Spring _relief = Spring(
    k: AnimationConstants.springRelief.$1,
    c: AnimationConstants.springRelief.$2,
  );

  late final List<CharacterRig> rigs;
  late final List<StarRenderState> stars;

  AnimationState _state = AnimationState.initial();
  AnimationState get state => _state;

  bool _isDisposed = false;
  final bool prefersReducedMotion;

  final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );
  final Map<String, double> _textWidthCache = {};

  OgletAnimationEngine({
    TickerProvider? vsync,
    this.prefersReducedMotion = false,
  }) {
    rigs = [
      for (int i = 0; i < CrewData.crew.length; i++)
        CharacterRig(CrewData.crew[i], i),
    ];
    stars = CrewData.stars
        .map((s) => StarRenderState(s))
        .toList(growable: false);

    if (prefersReducedMotion) {
      // Simulate up to AnimationConstants.stillAt (12s) in 1/60s steps
      final int steps = (AnimationConstants.stillAt * 60).round();
      const double stepDt = 1.0 / 60.0;
      for (int k = 0; k <= steps; k++) {
        _tickSimulation(k * stepDt);
      }
    } else if (vsync != null) {
      _ticker = vsync.createTicker(_handleTick);
      _ticker!.start();
    }
  }

  void start(TickerProvider vsync) {
    if (prefersReducedMotion) return;
    _ticker?.dispose();
    _ticker = vsync.createTicker(_handleTick);
    _ticker!.start();
  }

  void _handleTick(Duration elapsed) {
    if (_isDisposed) return;
    final double elapsedSeconds = elapsed.inMicroseconds / 1000000.0;
    _tickSimulation(elapsedSeconds);
    notifyListeners();
  }

  void _tickSimulation(double nowSeconds) {
    final double T = nowSeconds;
    _startTime ??= T;

    final double dt = _lastTime == null
        ? 1.0 / 60.0
        : math.min(0.05, T - _lastTime!);
    _lastTime = T;

    final double t = (T - _startTime!) % AnimationConstants.loopDuration;
    final BeatState beat = TimelineData.calculateBeat(t);

    // Email field shake: 2.5 swings, 8px, dying out
    final double uShake = MathUtils.clamp(
      (t - AnimationConstants.atError) / 0.55,
    );
    final double emailShakeX =
        math.sin(uShake * math.pi * 5.0) * 8.0 * (1.0 - uShake);

    // Button press dip
    final double pr = math.max(
      0.0,
      1.0 -
          math.min(
                (t - AnimationConstants.presses[0]).abs(),
                (t - AnimationConstants.presses[1]).abs(),
              ) /
              0.12,
    );
    final double buttonPressScale = 1.0 - 0.05 * pr;

    // Spinner angle
    final double spinnerAngle = (T * 540.0) * (math.pi / 180.0);

    // Title blur and subtitle text states
    final double tw = math.max(
      0.0,
      1.0 - (t - AnimationConstants.atTitle).abs() / 0.25,
    );
    final double titleBlur = tw > 0.02 ? tw * 8.0 : 0.0;
    final bool isTitleDone =
        t > AnimationConstants.atTitle && t < AnimationConstants.atDoneEnd;
    final bool isSubtitleDone = isTitleDone;
    final bool isSubtitleError =
        t > AnimationConstants.atError && t < AnimationConstants.atErrorEnd;

    // Target look coordinate
    Offset tg = const Offset(200.0, 520.0);
    for (final tap in TimelineData.taps) {
      if (t >= tap.time) {
        tg = Offset(tap.x, tap.y);
      }
    }
    if (beat.focusedField >= 0) {
      tg = _caretAt(beat.focusedField, beat);
    }
    if (beat.isDone) {
      tg = const Offset(200.0, 300.0);
    }

    _look = Offset(
      _look.dx + (tg.dx - _look.dx) * math.min(1.0, dt * 6.0),
      _look.dy + (tg.dy - _look.dy) * math.min(1.0, dt * 6.0),
    );

    // Tap indicator
    bool tapActive = false;
    Offset tapPos = Offset.zero;
    double tapOpacity = 0.0;
    double tapScale = 0.6;

    for (final tap in TimelineData.taps) {
      final double uTap = (t - tap.time) / 0.45;
      if (uTap > 0.0 && uTap < 1.0) {
        tapPos = Offset(tap.x - 22.0, tap.y - 22.0);
        tapOpacity = math.sin(math.pi * uTap);
        tapScale = 0.6 + 0.6 * uTap;
        tapActive = true;
        break;
      }
    }

    // Step shared crew moods
    final double fadeOut =
        1.0 -
        MathUtils.seg(
          t,
          AnimationConstants.atFadeOut,
          AnimationConstants.loopDuration,
        );

    final double pt = _prevLoopTime ?? t;
    _prevLoopTime = t;

    // Comprehensive reset on timeline loop wrap
    if (t < pt) {
      _worry.reset();
      _joy.reset();
      _relief.reset();
      _look = const Offset(200.0, 420.0);
      for (final rig in rigs) {
        rig.reset();
      }
    }

    _worry.step(beat.isError ? 1.0 : 0.0, dt);
    _joy.step(beat.isDone ? 1.0 : 0.0, dt);
    _relief.step((beat.isValid && !beat.isDone) ? 1.0 : 0.0, dt);

    final double er = MathUtils.clamp(_worry.x, 0.0, 1.2);
    final double jy = MathUtils.clamp(_joy.x, 0.0, 1.2);
    final double okk = MathUtils.clamp(_relief.x, 0.0, 1.2);

    bool crossed(double x) => pt < x && t >= x;

    for (int ci = 0; ci < rigs.length; ci++) {
      final CharacterRig c = rigs[ci];
      final MemberDefinition m = c.member;

      // Flinch / head shake / squash kicks
      if (crossed(AnimationConstants.atError + ci * 0.04)) {
        c.shake.v += (ci % 2 != 0 ? -1.0 : 1.0) * 260.0;
        c.sq.v -= 7.0;
      }
      if (crossed(AnimationConstants.atFixed + ci * 0.05)) {
        c.sq.v += 4.0;
      }
      for (final double h in AnimationConstants.hops) {
        if (crossed(h + ci * 0.07)) {
          c.hop.v -= 420.0;
          c.sq.v -= 10.0;
        }
      }

      c.hop.step(0.0, dt);
      c.shake.step(0.0, dt);
      c.sq.step(0.0, dt);

      // Pop in with overshoot
      final double pop = MathUtils.clamp((t - m.delay) / 0.6);
      final double ps = pop < 1.0
          ? MathUtils.eio(pop) * (1.0 + math.sin(pop * math.pi) * 0.16)
          : 1.0;

      // Lean toward look target
      final double dx = _look.dx - m.x;
      final double dy = _look.dy - m.y;
      c.lean.step(MathUtils.clamp(dx / 300.0, -1.0, 1.0) * 5.0, dt);

      // Stretch & squash & breathing
      final double vy = c.hop.v;
      final double stretch =
          MathUtils.clamp(-vy / 1800.0, -0.12, 0.14) + c.sq.x * 0.012;
      final double sx =
          ps *
          fadeOut *
          (1.0 - stretch * 0.6) *
          (1.0 + math.sin(T * 2.0 + ci) * 0.012);
      final double sy =
          ps *
          fadeOut *
          (1.0 + stretch) *
          (1.0 - er * 0.04) *
          (1.0 + math.sin(T * 2.0 + ci + 1.0) * 0.012);

      c.rootTranslation = Offset(m.x, m.y + c.hop.x * 0.06);
      c.rootRotationDeg =
          m.rotation +
          c.lean.x +
          c.shake.x * 0.06 +
          math.sin(T * 1.1 + ci) * 1.2;
      c.scaleX = sx;
      c.scaleY = sy;

      // Face turning toward look target
      final double ang = (-m.rotation * math.pi) / 180.0;
      final double rx0 = dx * math.cos(ang) - dy * math.sin(ang);
      final double ry0 = dx * math.sin(ang) + dy * math.cos(ang);
      final double dd = math.sqrt(rx0 * rx0 + ry0 * ry0);
      final double safeDd = dd == 0.0 ? 1.0 : dd;

      c.turnX.step((rx0 / safeDd) * 7.0, dt);
      c.turnY.step((ry0 / safeDd) * 5.0, dt);
      c.faceTranslation = Offset(c.turnX.x, c.turnY.x);

      // Eye rig updates
      for (int k = 0; k < c.eyes.length; k++) {
        final eye = c.eyes[k];
        final double ex = _look.dx - (m.x + eye.x);
        final double ey = _look.dy - (m.y + eye.y);
        final double rx = ex * math.cos(ang) - ey * math.sin(ang);
        final double ry = ex * math.sin(ang) + ey * math.cos(ang);
        final double dEye = math.sqrt(rx * rx + ry * ry);
        final double safeDEye = dEye == 0.0 ? 1.0 : dEye;
        final double reach = eye.r * 0.42;

        final double tx = (rx / safeDEye) * reach * math.min(1.0, dEye / 70.0);
        final double ty = (ry / safeDEye) * reach * math.min(1.0, dEye / 70.0);

        eye.vx +=
            (AnimationConstants.springPupil.$1 * (tx - eye.px) -
                AnimationConstants.springPupil.$2 * eye.vx) *
            dt;
        eye.vy +=
            (AnimationConstants.springPupil.$1 * (ty - eye.py) -
                    AnimationConstants.springPupil.$2 * eye.vy) *
                dt +
            c.hop.v * 0.0016;
        eye.vx += c.shake.v * 0.0012;
        eye.px += eye.vx * dt;
        eye.py += eye.vy * dt;

        final double prEye = math.sqrt(eye.px * eye.px + eye.py * eye.py);
        if (prEye > reach * 1.15) {
          final double factor = (reach * 1.15) / prEye;
          eye.px *= factor;
          eye.py *= factor;
        }

        final double pupR = eye.r * (0.52 - 0.12 * er + 0.04 * okk);
        eye.pupilRadius = pupR;

        // Eye blinking
        final double ph = (T + ci * 0.83) % 4.6;
        final double bl = ph < 0.16 ? math.sin((ph / 0.16) * math.pi) : 0.0;
        final double lidH = math.max(bl, er * 0.3);
        eye.lidHeight = lidH;

        final double hj = MathUtils.clamp(jy);
        eye.normalEyeOpacity = 1.0 - hj;
        eye.happyOpacity = hj;

        final double big = 1.0 + er * 0.1;
        eye.whiteRadius = eye.r * big;
        eye.clipRadius = eye.r * big + 1.5;

        final int side = c.eyes.length == 1 ? 0 : (k == 0 ? 1 : -1);
        eye.browOpacity = MathUtils.clamp(er);
        eye.browTranslationY = -3.0 * er;
        eye.browRotation = side * -18.0 * er;
      }

      // Extras: sweat, blush, heart
      final double sw = (T * 0.9 + ci * 0.3) % 1.0;
      c.sweatTranslation = Offset(m.sweatAt.dx, m.sweatAt.dy + sw * 14.0);
      c.sweatOpacity = MathUtils.clamp(er) * (1.0 - sw);

      c.blushOpacity = MathUtils.clamp(jy) * 0.9;

      final double hf = (T * 0.7 + ci * 0.37) % 1.0;
      c.heartTranslation = Offset(
        m.heartAt.dx + math.sin(hf * 6.0) * 3.0,
        m.heartAt.dy - hf * 22.0,
      );
      c.heartScale = 0.8 + 0.3 * hf;
      c.heartOpacity = MathUtils.clamp(jy) * math.sin(math.pi * hf);

      // Mouth & tongue morphing
      final double mx = m.mouth.x;
      final double my = m.mouth.y;
      final double mw = m.mouth.halfWidth;
      final double sm =
          MathUtils.lerp(0.25, -0.85, MathUtils.clamp(er)) *
              (1.0 - math.max(okk * 0.7, jy)) +
          math.max(okk * 0.55, jy);
      final double op = MathUtils.clamp(jy);
      final double w = mw * (1.0 + 0.15 * jy - 0.15 * er);
      final double cy1 = my + w * 0.85 * sm + op * w * 0.5;
      final double cy2 = my + op * w * 0.25;

      c.mouthPath = OrganicShapes.mouthPath(
        mx: mx,
        my: my,
        w: w,
        cy1: cy1,
        cy2: cy2,
      );
      c.mouthFillOpacity = op;

      c.tongueCenter = Offset(mx, my + w * 0.6 * op);
      c.tongueRadiusX = mw * 0.45 * op;
      c.tongueRadiusY = mw * 0.22 * op;
      c.tongueOpacity = op * 0.9;
    }

    // Stars update
    for (int i = 0; i < stars.length; i++) {
      final star = stars[i];
      final double twStar = 0.75 + 0.25 * math.sin(T * 3.0 + i * 1.7);
      final double b = 1.0 + jy * (0.6 + 0.4 * math.sin(T * 9.0 + i));
      star.scale = twStar * b * fadeOut;
      star.rotation = (T * 20.0 + i * 30.0) * (math.pi / 180.0);
    }

    // Phone opacity
    final double phoneOpacity =
        MathUtils.seg(t, 0.0, 0.4) *
        (1.0 - MathUtils.seg(t, 17.5, AnimationConstants.loopDuration));

    _state = AnimationState(
      t: t,
      T: T,
      beat: beat,
      emailShakeX: emailShakeX,
      phoneOpacity: phoneOpacity,
      buttonPressScale: buttonPressScale,
      spinnerAngle: spinnerAngle,
      titleBlur: titleBlur,
      isTitleDone: isTitleDone,
      isSubtitleDone: isSubtitleDone,
      isSubtitleError: isSubtitleError,
      tapActive: tapActive,
      tapPosition: tapPos,
      tapScale: tapScale,
      tapOpacity: tapOpacity,
      fadeOut: fadeOut,
    );
  }

  Offset _caretAt(int fieldIndex, BeatState beat) {
    const double fieldLeft = DesignTokens.fieldInset;
    const double fieldPad = DesignTokens.fieldPaddingHorizontal;
    const double textStartX = fieldLeft + fieldPad;

    switch (fieldIndex) {
      case 0:
        // Name field
        final String text = beat.displayedName;
        final double width = _measureCachedText(
          'name:$text',
          text,
          const TextStyle(
            fontFamily: DesignTokens.fontFamily,
            fontSize: DesignTokens.fieldSize,
            fontWeight: DesignTokens.fieldWeight,
          ),
        );
        return Offset(textStartX + width + 1.0, 400.0);

      case 1:
        // Email field
        final String text = beat.email;
        final double width = _measureCachedText(
          'email:$text',
          text,
          const TextStyle(
            fontFamily: DesignTokens.fontFamily,
            fontSize: DesignTokens.fieldSize,
            fontWeight: DesignTokens.fieldWeight,
          ),
        );
        return Offset(textStartX + width + 1.0, 486.0);

      case 2:
        // Password field
        final String dots = OgletContent.passwordDot * beat.passwordDots;
        final double width = _measureCachedText(
          'pass:${beat.passwordDots}',
          dots,
          const TextStyle(
            fontFamily: DesignTokens.fontFamily,
            fontSize: DesignTokens.fieldSize,
            fontWeight: DesignTokens.fieldWeight,
            letterSpacing: DesignTokens.dotsTracking,
          ),
        );
        return Offset(textStartX + width + 1.0, 588.0);

      default:
        return const Offset(200.0, 420.0);
    }
  }

  double _measureCachedText(String key, String text, TextStyle style) {
    if (text.isEmpty) return 0.0;
    return _textWidthCache.putIfAbsent(key, () {
      _textPainter.text = TextSpan(text: text, style: style);
      _textPainter.layout();
      return _textPainter.width;
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _ticker?.dispose();
    _textPainter.dispose();
    _textWidthCache.clear();
    super.dispose();
  }
}
