import 'package:flutter/widgets.dart';

import 'package:rafi_login_template/src/core/constants/design_tokens.dart';
import 'package:rafi_login_template/src/core/geometry/organic_shapes.dart';
import 'package:rafi_login_template/src/data/crew_data.dart';
import 'package:rafi_login_template/src/engine/rafi_animation_engine.dart';

/// CustomPainter rendering twinkling decorative stars and sparkles.
class StarsPainter extends CustomPainter {
  final RafiAnimationEngine engine;

  static final Paint _starPaint = Paint()
    ..color = RafiDesignTokens.characterInk.withValues(alpha: 0.55)
    ..strokeWidth = 1.6
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  static final List<Path> _cachedStarPaths = [
    for (final star in CrewData.stars) OrganicShapes.starPath(star.radius),
  ];

  StarsPainter({required this.engine}) : super(repaint: engine);

  @override
  void paint(Canvas canvas, Size size) {
    final stars = engine.stars;
    for (int i = 0; i < stars.length; i++) {
      final star = stars[i];
      if (star.scale <= 0.001) continue;

      canvas.save();
      canvas.translate(star.definition.x, star.definition.y);
      canvas.rotate(star.rotation);
      canvas.scale(star.scale, star.scale);

      canvas.drawPath(_cachedStarPaths[i], _starPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant StarsPainter oldDelegate) => false;
}
