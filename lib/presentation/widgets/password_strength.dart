import 'package:flutter/widgets.dart';
import 'package:oglet/core/constants/design_tokens.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final int passwordDots;
  final int maxDots;

  const PasswordStrengthMeter({
    super.key,
    required this.passwordDots,
    this.maxDots = 9,
  });

  @override
  Widget build(BuildContext context) {
    final double fraction = (passwordDots / maxDots).clamp(0.0, 1.0);
    final Color fillColor = passwordDots < 4
        ? DesignTokens.weak
        : DesignTokens.strong;

    return Positioned(
      left: DesignTokens.meterInset,
      right: DesignTokens.meterInset,
      top: DesignTokens.meterTop,
      height: DesignTokens.meterHeight,
      child: Container(
        decoration: BoxDecoration(
          color: DesignTokens.meterTrack,
          borderRadius: BorderRadius.circular(DesignTokens.meterRadius),
        ),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: fraction,
          heightFactor: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(DesignTokens.meterRadius),
            ),
          ),
        ),
      ),
    );
  }
}
