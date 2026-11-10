import 'package:flutter/widgets.dart';
import 'package:rafi_login_template/src/core/constants/design_tokens.dart';
import 'package:rafi_login_template/src/data/rafi_login_content.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.0,
      child: Stack(
        children: [
          // Time
          const Positioned(
            left: DesignTokens.timeLeft,
            top: DesignTokens.timeTop,
            child: Text(
              RafiLoginContent.time,
              style: TextStyle(
                fontFamily: RafiDesignTokens.fontFamily,
                package: RafiDesignTokens.fontPackage,
                fontSize: RafiDesignTokens.timeSize,
                fontWeight: RafiDesignTokens.timeWeight,
                color: RafiDesignTokens.ink,
                height: 1.0,
              ),
            ),
          ),

          // Dynamic Island
          Positioned(
            left: DesignTokens.islandLeft,
            top: DesignTokens.islandTop,
            width: DesignTokens.islandWidth,
            height: DesignTokens.islandHeight,
            child: Container(
              decoration: const BoxDecoration(
                color: DesignTokens.ink,
                borderRadius: BorderRadius.all(
                  Radius.circular(DesignTokens.islandRadius),
                ),
              ),
            ),
          ),

          // Status Icons: Signal Bars & Battery
          const Positioned(
            right: DesignTokens.statusRight,
            top: DesignTokens.statusTop,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Signal bars
                CustomPaint(
                  size: Size(18.0, 11.0),
                  painter: _SignalBarsPainter(),
                ),
                SizedBox(width: DesignTokens.statusGap),
                // Battery icon
                CustomPaint(size: Size(26.0, 12.0), painter: _BatteryPainter()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalBarsPainter extends CustomPainter {
  const _SignalBarsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = DesignTokens.ink
      ..style = PaintingStyle.fill;

    // 4 bars matching original SVG
    // 1: x: 0, y: 7, w: 3, h: 4, rx: 1
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.0, 7.0, 3.0, 4.0),
        const Radius.circular(1.0),
      ),
      paint,
    );
    // 2: x: 5, y: 5, w: 3, h: 6, rx: 1
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(5.0, 5.0, 3.0, 6.0),
        const Radius.circular(1.0),
      ),
      paint,
    );
    // 3: x: 10, y: 2.5, w: 3, h: 8.5, rx: 1
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(10.0, 2.5, 3.0, 8.5),
        const Radius.circular(1.0),
      ),
      paint,
    );
    // 4: x: 15, y: 0, w: 3, h: 11, rx: 1
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(15.0, 0.0, 3.0, 11.0),
        const Radius.circular(1.0),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BatteryPainter extends CustomPainter {
  const _BatteryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = DesignTokens.ink.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Paint fillPaint = Paint()
      ..color = DesignTokens.ink
      ..style = PaintingStyle.fill;

    // Outer rect: x: 0.5, y: 0.5, w: 22, h: 11, rx: 3.5
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.5, 0.5, 22.0, 11.0),
        const Radius.circular(3.5),
      ),
      borderPaint,
    );

    // Inner fill: x: 2.5, y: 2.5, w: 16, h: 7, rx: 2
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2.5, 2.5, 16.0, 7.0),
        const Radius.circular(2.0),
      ),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
