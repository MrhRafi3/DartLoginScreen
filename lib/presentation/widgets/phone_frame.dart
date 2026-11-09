import 'package:flutter/widgets.dart';

import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/data/crew_data.dart';
import 'package:oglet/engine/oglet_animation_engine.dart';
import 'package:oglet/painters/character_painter.dart';
import 'package:oglet/painters/stars_painter.dart';
import 'package:oglet/presentation/widgets/signup_form.dart';
import 'package:oglet/presentation/widgets/status_bar.dart';
import 'package:oglet/presentation/widgets/tap_indicator.dart';

class PhoneFrame extends StatelessWidget {
  final OgletAnimationEngine engine;
  final Widget? form;

  const PhoneFrame({super.key, required this.engine, this.form});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left:
          DesignTokens.phoneLeft -
          DesignTokens.innerRing -
          DesignTokens.outerRing, // 328.5
      top:
          DesignTokens.phoneTop -
          DesignTokens.innerRing -
          DesignTokens.outerRing, // 98.5
      width:
          DesignTokens.phoneWidth +
          (DesignTokens.innerRing + DesignTokens.outerRing) * 2, // 423.0
      height:
          DesignTokens.phoneHeight +
          (DesignTokens.innerRing + DesignTokens.outerRing) * 2, // 883.0
      child: ListenableBuilder(
        listenable: engine,
        builder: (context, staticPhoneShell) {
          return Opacity(
            opacity: engine.state.phoneOpacity.clamp(0.0, 1.0),
            child: staticPhoneShell,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.outerRing), // 1.5px
          decoration: BoxDecoration(
            color: DesignTokens.ringOuter, // #3A3542
            borderRadius: BorderRadius.circular(
              DesignTokens.phoneRadius +
                  DesignTokens.innerRing +
                  DesignTokens.outerRing, // 71.5
            ),
            boxShadow: const [
              BoxShadow(
                color: DesignTokens.phoneShadowColor,
                offset: Offset(0.0, 60.0),
                blurRadius: 120.0,
                spreadRadius: -40.0,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(DesignTokens.innerRing), // 10px
            decoration: BoxDecoration(
              color: DesignTokens.ringInner, // #141218
              borderRadius: BorderRadius.circular(
                DesignTokens.phoneRadius + DesignTokens.innerRing, // 70.0
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                DesignTokens.phoneRadius,
              ), // 60.0
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (event) {
                  engine.triggerTap(event.localPosition);
                },
                child: Container(
                  width: DesignTokens.phoneWidth, // 400.0
                  height: DesignTokens.phoneHeight, // 860.0
                  color: DesignTokens.screen, // #EFEBE4
                  child: Stack(
                    children: [
                      // Layer 1: Sparkles & Back characters (Cookie, Bean, Sun)
                      Positioned.fill(
                        child: RepaintBoundary(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: StarsPainter(engine: engine),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: RepaintBoundary(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: CharacterPainter(
                                engine: engine,
                                layer: CharacterLayer.back,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Layer 2: Status bar (completely static, cached)
                      const Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        height: 54.0,
                        child: RepaintBoundary(child: StatusBar()),
                      ),

                      // Layer 3: Sign-up / Login form (Title, fields, meter, button, footer)
                      Positioned.fill(
                        child: RepaintBoundary(
                          child:
                              form ??
                              ListenableBuilder(
                                listenable: engine,
                                builder: (context, _) {
                                  return SignupForm(state: engine.state);
                                },
                              ),
                        ),
                      ),

                      // Layer 4: Front characters (Wobble, Pebble)
                      Positioned.fill(
                        child: RepaintBoundary(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: CharacterPainter(
                                engine: engine,
                                layer: CharacterLayer.front,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Layer 5: Tap indicator ring
                      ListenableBuilder(
                        listenable: engine,
                        builder: (context, _) {
                          final state = engine.state;
                          return TapIndicator(
                            active: state.tapActive,
                            position: state.tapPosition,
                            scale: state.tapScale,
                            opacity: state.tapOpacity,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
