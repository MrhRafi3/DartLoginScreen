import 'package:flutter/material.dart';
import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/data/oglet_content.dart';

/// Interactive Oglet form field with real text input, focus tracking,
/// password visibility toggle, checkmark indicator, and shake animation.
class OgletFormField extends StatelessWidget {
  final String label;
  final double labelTop;
  final double inputTop;
  final String placeholder;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePasswordVisibility;
  final bool isError;
  final String? errorMessage;
  final double shakeX;
  final bool showCheck;
  final double checkOpacity;
  final double checkScale;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final Key? fieldKey;

  const OgletFormField({
    super.key,
    required this.label,
    required this.labelTop,
    required this.inputTop,
    required this.placeholder,
    required this.controller,
    required this.focusNode,
    this.isPassword = false,
    this.obscureText = true,
    this.onTogglePasswordVisibility,
    this.isError = false,
    this.errorMessage,
    this.shakeX = 0.0,
    this.showCheck = false,
    this.checkOpacity = 0.0,
    this.checkScale = 1.0,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
    this.enabled = true,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: focusNode,
      builder: (context, _) {
        final bool isFocused = focusNode.hasFocus;
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
                    borderRadius: BorderRadius.circular(
                      DesignTokens.fieldRadius,
                    ),
                    border: Border.all(color: borderColor, width: borderWidth),
                  ),
                  child: Row(
                    children: [
                      // Real editable text field
                      Expanded(
                        child: Semantics(
                          label: label,
                          child: TextField(
                            key: fieldKey,
                            controller: controller,
                            focusNode: focusNode,
                            obscureText: isPassword && obscureText,
                            obscuringCharacter: OgletContent.passwordDot,
                            enabled: enabled,
                            keyboardType: keyboardType,
                            textInputAction: textInputAction,
                            onChanged: onChanged,
                            onSubmitted: onSubmitted,
                            autofillHints: autofillHints,
                            style: TextStyle(
                              fontFamily: DesignTokens.fontFamily,
                              fontSize: DesignTokens.fieldSize,
                              fontWeight: DesignTokens.fieldWeight,
                              letterSpacing: (isPassword && obscureText)
                                  ? DesignTokens.dotsTracking
                                  : null,
                              color: DesignTokens.ink,
                              height: 1.0,
                            ),
                            cursorColor: DesignTokens.ink,
                            cursorWidth: DesignTokens.caretWidth,
                            cursorRadius: const Radius.circular(
                              DesignTokens.caretRadius,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintText: placeholder,
                              hintStyle: const TextStyle(
                                fontFamily: DesignTokens.fontFamily,
                                fontSize: DesignTokens.fieldSize,
                                fontWeight: DesignTokens.placeholderWeight,
                                color: DesignTokens.placeholder,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Password Visibility Toggle
                      if (isPassword)
                        GestureDetector(
                          key: const Key('password_visibility_toggle'),
                          onTap: onTogglePasswordVisibility,
                          behavior: HitTestBehavior.opaque,
                          child: Semantics(
                            button: true,
                            label: obscureText
                                ? 'Show password'
                                : 'Hide password',
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 48.0,
                                minHeight: 48.0,
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                obscureText
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20.0,
                                color: isFocused
                                    ? DesignTokens.ink
                                    : DesignTokens.muted,
                              ),
                            ),
                          ),
                        ),

                      // Green Checkmark indicator (for valid identifier)
                      if (showCheck && !isPassword)
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

            // Inline Error Message
            if (isError && errorMessage != null && errorMessage!.isNotEmpty)
              Positioned(
                left: DesignTokens.errorLeft,
                right: DesignTokens.fieldInset,
                top: inputTop + DesignTokens.fieldHeight + 4.0,
                child: Text(
                  errorMessage!,
                  maxLines: 2,
                  softWrap: true,
                  style: const TextStyle(
                    fontFamily: DesignTokens.fontFamily,
                    fontSize: DesignTokens.errorSize,
                    fontWeight: DesignTokens.errorWeight,
                    color: DesignTokens.error,
                    height: 1.1,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
