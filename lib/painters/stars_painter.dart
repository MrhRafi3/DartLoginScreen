import 'package:flutter/widgets.dart';

import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/core/geometry/organic_shapes.dart';
import 'package:oglet/data/crew_data.dart';
import 'package:oglet/engine/oglet_animation_engine.dart';

class StarsPainter extends CustomPainter {
  final OgletAnimationEngine engine;

  static final Paint _starPaint = Paint()
    ..color = DesignTokens.characterInk.withValues(alpha: 0.55)
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
