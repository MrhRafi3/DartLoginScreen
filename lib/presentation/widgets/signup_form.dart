import 'dart:ui';
import 'package:flutter/widgets.dart';

import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/data/oglet_content.dart';
import 'package:oglet/engine/animation_state.dart';
import 'package:oglet/presentation/widgets/password_strength.dart';
import 'package:oglet/presentation/widgets/signup_button.dart';

/// Legacy display widget maintained for visual compatibility.
/// For production interactive authentication, use [OgletLoginForm] or [OgletLoginScreen].
class SignupForm extends StatelessWidget {
  final AnimationState state;

  const SignupForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
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

        // Static visual placeholders for legacy preview
        const Positioned(
          left: DesignTokens.labelLeft,
          top: DesignTokens.emailLabelTop,
          child: Text(
            OgletContent.emailLabel,
            style: TextStyle(
              fontFamily: DesignTokens.fontFamily,
              fontSize: DesignTokens.labelSize,
              fontWeight: DesignTokens.labelWeight,
              color: DesignTokens.muted,
            ),
          ),
        ),

        // Password Strength Meter
        PasswordStrengthMeter(
          passwordDots: state.beat.passwordDots,
          maxDots: OgletContent.passwordLength,
        ),

        // Main Signup Button
        SignupButton(
          isLoading: state.isLoading,
          isDone: state.isSuccess,
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
