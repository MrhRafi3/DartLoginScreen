import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/data/oglet_content.dart';

class SignupButton extends StatelessWidget {
  final bool isLoading;
  final bool isDone;
  final double pressScale;
  final double spinnerAngle;

  const SignupButton({
    super.key,
    required this.isLoading,
    required this.isDone,
    required this.pressScale,
    required this.spinnerAngle,
  });

  @override
  Widget build(BuildContext context) {
    final String label = isDone
        ? OgletContent.buttonDone
        : (isLoading ? OgletContent.buttonLoading : OgletContent.button);

    final Color backgroundColor = isDone
        ? DesignTokens.ok
        : DesignTokens.buttonFill;

    return Positioned(
      left: DesignTokens.buttonInset,
      right: DesignTokens.buttonInset,
      top: DesignTokens.buttonTop,
      height: DesignTokens.buttonHeight,
      child: Transform.scale(
        scale: pressScale,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(DesignTokens.buttonRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: DesignTokens.fontFamily,
                  fontSize: DesignTokens.buttonSize,
                  fontWeight: DesignTokens.buttonWeight,
                  color: DesignTokens.buttonText,
                  height: 1.0,
                ),
              ),
              if (isLoading) ...[
                const SizedBox(width: DesignTokens.buttonGap),
                Transform.rotate(
                  angle: spinnerAngle,
                  child: const CustomPaint(
                    size: Size(
                      DesignTokens.spinnerSize,
                      DesignTokens.spinnerSize,
                    ),
                    painter: _SpinnerPainter(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 8.0;
    const Offset center = Offset(10.0, 10.0);

    // Track
    final Paint trackPaint = Paint()
      ..color = DesignTokens.spinnerTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = DesignTokens.spinnerWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Active arc (90 degrees / quarter circle from top: -pi/2 to 0)
    final Paint arcPaint = Paint()
      ..color = DesignTokens.buttonText
      ..style = PaintingStyle.stroke
      ..strokeWidth = DesignTokens.spinnerWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2.0,
      math.pi / 2.0,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
