import 'package:flutter/widgets.dart';
import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/data/oglet_content.dart';

class OgletFormField extends StatelessWidget {
  final String label;
  final double labelTop;
  final double inputTop;
  final String placeholder;
  final String value;
  final bool isPassword;
  final bool isFocused;
  final bool isError;
  final bool caretVisible;
  final double shakeX;
  final bool showCheck;
  final double checkOpacity;
  final double checkScale;

  const OgletFormField({
    super.key,
    required this.label,
    required this.labelTop,
    required this.inputTop,
    required this.placeholder,
    required this.value,
    this.isPassword = false,
    this.isFocused = false,
    this.isError = false,
    this.caretVisible = false,
    this.shakeX = 0.0,
    this.showCheck = false,
    this.checkOpacity = 0.0,
    this.checkScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isError
        ? DesignTokens.error
        : (isFocused ? DesignTokens.ink : DesignTokens.fieldEdge);
    final double borderWidth = (isError || isFocused) ? 2.0 : 1.5;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Label
        Positioned(
          left: DesignTokens.labelLeft,
          top: labelTop,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: DesignTokens.fontFamily,
              fontSize: DesignTokens.labelSize,
              fontWeight: DesignTokens.labelWeight,
              letterSpacing: DesignTokens.labelTracking,
              color: DesignTokens.muted,
              height: 1.0,
            ),
          ),
        ),

        // Input Field Box
        Positioned(
          left: DesignTokens.fieldInset,
          right: DesignTokens.fieldInset,
          top: inputTop,
          height: DesignTokens.fieldHeight,
          child: Transform.translate(
            offset: Offset(shakeX, 0.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.fieldPaddingHorizontal,
              ),
              decoration: BoxDecoration(
                color: DesignTokens.fieldFill,
                borderRadius: BorderRadius.circular(DesignTokens.fieldRadius),
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: Row(
                children: [
                  // Text Content or Placeholder
                  if (value.isEmpty)
                    Text(
                      placeholder,
                      style: const TextStyle(
                        fontFamily: DesignTokens.fontFamily,
                        fontSize: DesignTokens.fieldSize,
                        fontWeight: DesignTokens.placeholderWeight,
                        color: DesignTokens.placeholder,
                        height: 1.0,
                      ),
                    )
                  else
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: DesignTokens.fontFamily,
                        fontSize: DesignTokens.fieldSize,
                        fontWeight: DesignTokens.fieldWeight,
                        letterSpacing: isPassword
                            ? DesignTokens.dotsTracking
                            : null,
                        color: DesignTokens.ink,
                        height: 1.0,
                      ),
                    ),

                  // Blinking Caret
                  if (isFocused)
                    Opacity(
                      opacity: caretVisible ? 1.0 : 0.0,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: DesignTokens.caretGap,
                        ),
                        width: DesignTokens.caretWidth,
                        height: DesignTokens.caretHeight,
                        decoration: BoxDecoration(
                          color: DesignTokens.ink,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.caretRadius,
                          ),
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Green Checkmark indicator (for Email)
                  if (showCheck)
                    Opacity(
                      opacity: checkOpacity,
                      child: Transform.scale(
                        scale: checkScale,
                        child: Container(
                          width: DesignTokens.checkSize,
                          height: DesignTokens.checkSize,
                          decoration: const BoxDecoration(
                            color: DesignTokens.ok,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            OgletContent.check,
                            style: TextStyle(
                              color: DesignTokens.onOk,
                              fontSize: DesignTokens.checkFontSize,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
