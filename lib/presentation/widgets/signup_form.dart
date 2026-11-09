import 'dart:ui';
import 'package:flutter/widgets.dart';

import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/data/oglet_content.dart';
import 'package:oglet/engine/animation_state.dart';
import 'package:oglet/presentation/widgets/form_field.dart';
import 'package:oglet/presentation/widgets/password_strength.dart';
import 'package:oglet/presentation/widgets/signup_button.dart';

class SignupForm extends StatelessWidget {
  final AnimationState state;

  const SignupForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Caret blink cycle: 0.5s on, 0.5s off
    final bool caretBlink = (state.T * 2.0).floor() % 2 == 0;

    final String titleText = state.isTitleDone
        ? OgletContent.titleDone
        : OgletContent.title;
    final String subtitleText = state.isSubtitleDone
        ? OgletContent.subtitleDone
        : (state.isSubtitleError
              ? OgletContent.subtitleError
              : OgletContent.subtitle);

    Widget titleWidget = Text(
      titleText,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: DesignTokens.fontFamily,
        fontSize: DesignTokens.titleSize,
        fontWeight: DesignTokens.titleWeight,
        letterSpacing: DesignTokens.titleTracking,
        color: DesignTokens.ink,
        height: 1.0,
      ),
    );

    if (state.titleBlur > 0.02) {
      titleWidget = ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: state.titleBlur,
          sigmaY: state.titleBlur,
        ),
        child: titleWidget,
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Title
        Positioned(
          left: 0.0,
          right: 0.0,
          top: DesignTokens.titleTop,
          child: titleWidget,
        ),

        // Subtitle
        Positioned(
          left: 0.0,
          right: 0.0,
          top: DesignTokens.subtitleTop,
          child: Text(
            subtitleText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: DesignTokens.fontFamily,
              fontSize: DesignTokens.subtitleSize,
              fontWeight: DesignTokens.subtitleWeight,
              color: DesignTokens.muted,
              height: 1.0,
            ),
          ),
        ),

        // Name Field
        OgletFormField(
          label: OgletContent.nameLabel,
          labelTop: DesignTokens.nameLabelTop,
          inputTop: DesignTokens.nameTop,
          placeholder: OgletContent.namePlaceholder,
          value: state.beat.displayedName,
          isFocused: state.beat.focusedField == 0,
          caretVisible: caretBlink,
        ),

        // Email Field
        OgletFormField(
          label: OgletContent.emailLabel,
          labelTop: DesignTokens.emailLabelTop,
          inputTop: DesignTokens.emailTop,
          placeholder: OgletContent.emailPlaceholder,
          value: state.beat.email,
          isFocused: state.beat.focusedField == 1,
          isError: state.beat.isError,
          shakeX: state.emailShakeX,
          caretVisible: caretBlink,
          showCheck: true,
          checkOpacity: state.beat.isValid ? 1.0 : 0.0,
          checkScale: state.beat.isValid ? 1.0 : 0.5,
        ),

        // Email Error Hint
        Positioned(
          left: DesignTokens.errorLeft,
          top: DesignTokens.errorTop,
          child: Opacity(
            opacity: state.beat.errorOpacity.clamp(0.0, 1.0),
            child: const Text(
              OgletContent.error,
              style: TextStyle(
                fontFamily: DesignTokens.fontFamily,
                fontSize: DesignTokens.errorSize,
                fontWeight: DesignTokens.errorWeight,
                color: DesignTokens.error,
                height: 1.0,
              ),
            ),
          ),
        ),

        // Password Field
        OgletFormField(
          label: OgletContent.passwordLabel,
          labelTop: DesignTokens.passwordLabelTop,
          inputTop: DesignTokens.passwordTop,
          placeholder: OgletContent.passwordPlaceholder,
          value: OgletContent.passwordDot * state.beat.passwordDots,
          isPassword: true,
          isFocused: state.beat.focusedField == 2,
          caretVisible: caretBlink,
        ),

        // Password Strength Meter
        PasswordStrengthMeter(
          passwordDots: state.beat.passwordDots,
          maxDots: OgletContent.passwordLength,
        ),

        // Main Signup Button
        SignupButton(
          isLoading: state.beat.isLoading,
          isDone: state.beat.isDone,
          pressScale: state.buttonPressScale,
          spinnerAngle: state.spinnerAngle,
        ),

        // Member Footer
        const Positioned(
          left: 0.0,
          right: 0.0,
          top: DesignTokens.memberTop,
          child: Center(
            child: Text.rich(
              TextSpan(
                text: '${OgletContent.member} ',
                style: TextStyle(
                  fontFamily: DesignTokens.fontFamily,
                  fontSize: DesignTokens.memberSize,
                  fontWeight: DesignTokens.memberWeight,
                  color: DesignTokens.muted,
                  height: 1.0,
                ),
                children: [
                  TextSpan(
                    text: OgletContent.login,
                    style: TextStyle(
                      fontFamily: DesignTokens.fontFamily,
                      fontSize: DesignTokens.memberSize,
                      fontWeight: DesignTokens.loginWeight,
                      color: DesignTokens.ink,
                      height: 1.0,
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
