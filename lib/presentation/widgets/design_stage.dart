import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:oglet/core/constants/design_tokens.dart';

class DesignStage extends StatelessWidget {
  final Widget child;

  const DesignStage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignTokens.paper,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Original scaling formula:
            // scale = min(screenWidth / 500, screenHeight / 1080)
            final double scale = math.min(
              constraints.maxWidth / DesignTokens.phoneSpan,
              constraints.maxHeight / DesignTokens.stageSize,
            );

            return Center(
              child: OverflowBox(
                minWidth: 0.0,
                maxWidth: double.infinity,
                minHeight: 0.0,
                maxHeight: double.infinity,
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: DesignTokens.stageSize,
                    height: DesignTokens.stageSize,
                    child: Stack(clipBehavior: Clip.none, children: [child]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
