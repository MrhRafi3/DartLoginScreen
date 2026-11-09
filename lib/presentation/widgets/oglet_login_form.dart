import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/data/oglet_content.dart';
import 'package:oglet/engine/oglet_animation_engine.dart';
import 'package:oglet/models/login_credentials.dart';
import 'package:oglet/presentation/widgets/form_field.dart';
import 'package:oglet/presentation/widgets/password_strength.dart';
import 'package:oglet/presentation/widgets/signup_button.dart';

/// Interactive Oglet login form supporting 2-field (identifier + password)
/// or 3-field (name + email + password) layout, with password visibility toggle,
/// inline validation, callbacks for forgot password and account creation,
/// and responsive character reaction synchronization.
class OgletLoginForm extends StatelessWidget {
  final OgletAnimationEngine engine;

  final TextEditingController identifierController;
  final FocusNode identifierFocusNode;
  final OgletIdentifierType identifierType;
  final String? identifierLabel;
  final String? identifierPlaceholder;
  final String? identifierError;
  final bool isIdentifierValid;

  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final String? passwordLabel;
  final String? passwordPlaceholder;
  final String? passwordError;
  final bool isPasswordObscured;
  final VoidCallback onTogglePasswordVisibility;

  final bool showNameField;
  final TextEditingController? nameController;
  final FocusNode? nameFocusNode;
  final String? nameError;

  final bool showPasswordStrength;

  final String? title;
  final String? subtitle;
  final String? authError;
  final bool isSuccess;
  final bool isLoading;

  final String? loginButtonText;
  final String? loginButtonLoadingText;
  final String? loginButtonSuccessText;
  final VoidCallback onLoginPressed;

  final VoidCallback? onForgotPassword;
  final VoidCallback? onCreateAccount;
  final String? footerPromptText;
  final String? footerActionText;

  const OgletLoginForm({
    super.key,
    required this.engine,
    required this.identifierController,
    required this.identifierFocusNode,
    this.identifierType = OgletIdentifierType.email,
    this.identifierLabel,
    this.identifierPlaceholder,
    this.identifierError,
    this.isIdentifierValid = false,
    required this.passwordController,
    required this.passwordFocusNode,
    this.passwordLabel,
    this.passwordPlaceholder,
    this.passwordError,
    required this.isPasswordObscured,
    required this.onTogglePasswordVisibility,
    this.showNameField = false,
    this.nameController,
    this.nameFocusNode,
    this.nameError,
    this.showPasswordStrength = false,
    this.title,
    this.subtitle,
    this.authError,
    this.isSuccess = false,
    this.isLoading = false,
    this.loginButtonText,
    this.loginButtonLoadingText,
    this.loginButtonSuccessText,
    required this.onLoginPressed,
    this.onForgotPassword,
    this.onCreateAccount,
    this.footerPromptText,
    this.footerActionText,
  });

  String _defaultIdentifierLabel() {
    switch (identifierType) {
      case OgletIdentifierType.email:
        return OgletContent.emailLabel;
      case OgletIdentifierType.username:
        return 'Username';
      case OgletIdentifierType.emailOrUsername:
        return 'Email or username';
      case OgletIdentifierType.name:
        return OgletContent.nameLabel;
    }
  }

  String _defaultIdentifierPlaceholder() {
    switch (identifierType) {
      case OgletIdentifierType.email:
        return OgletContent.emailPlaceholder;
      case OgletIdentifierType.username:
        return 'your_username';
      case OgletIdentifierType.emailOrUsername:
        return 'you@email.com or username';
      case OgletIdentifierType.name:
        return OgletContent.namePlaceholder;
    }
  }

  TextInputType _identifierKeyboardType() {
    switch (identifierType) {
      case OgletIdentifierType.email:
      case OgletIdentifierType.emailOrUsername:
        return TextInputType.emailAddress;
      case OgletIdentifierType.name:
        return TextInputType.name;
      case OgletIdentifierType.username:
        return TextInputType.text;
    }
  }

  Iterable<String> _identifierAutofillHints() {
    switch (identifierType) {
      case OgletIdentifierType.email:
        return const [AutofillHints.email];
      case OgletIdentifierType.username:
        return const [AutofillHints.username];
      case OgletIdentifierType.emailOrUsername:
        return const [AutofillHints.email, AutofillHints.username];
      case OgletIdentifierType.name:
        return const [AutofillHints.name];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Title and Subtitle calculation
    final String effectiveTitle = isSuccess
        ? (title ?? OgletContent.titleDone)
        : (title ?? OgletContent.title);

    String effectiveSubtitle = subtitle ?? OgletContent.subtitle;
    if (isSuccess) {
      effectiveSubtitle = OgletContent.subtitleDone;
    } else if (authError != null && authError!.isNotEmpty) {
      effectiveSubtitle = authError!;
    } else if (identifierError != null || passwordError != null) {
      effectiveSubtitle = OgletContent.subtitleError;
    }

    // Geometry layout: 3-field vs 2-field
    final double idLabelTop = showNameField
        ? DesignTokens.emailLabelTop
        : 366.0;
    final double idInputTop = showNameField ? DesignTokens.emailTop : 388.0;

    final double passLabelTop = showNameField
        ? DesignTokens.passwordLabelTop
        : 478.0;
    final double passInputTop = showNameField
        ? DesignTokens.passwordTop
        : 500.0;

    final double meterTop = showNameField ? DesignTokens.meterTop : 568.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Title with scoped blur listener
        Positioned(
          left: 0.0,
          right: 0.0,
          top: DesignTokens.titleTop,
          child: ListenableBuilder(
            listenable: engine,
            builder: (context, _) {
              Widget titleTextWidget = Text(
                effectiveTitle,
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

              final double blur = engine.state.titleBlur;
              if (blur > 0.02) {
                titleTextWidget = ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: titleTextWidget,
                );
              }
              return titleTextWidget;
            },
          ),
        ),

        // Subtitle
        Positioned(
          left: DesignTokens.fieldInset,
          right: DesignTokens.fieldInset,
          top: DesignTokens.subtitleTop,
          child: Text(
            effectiveSubtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: DesignTokens.fontFamily,
              fontSize: DesignTokens.subtitleSize,
              fontWeight: DesignTokens.subtitleWeight,
              color:
                  (authError != null ||
                      identifierError != null ||
                      passwordError != null)
                  ? DesignTokens.error
                  : DesignTokens.muted,
              height: 1.2,
            ),
          ),
        ),

        // Optional Name Field (3-field mode)
        if (showNameField && nameController != null && nameFocusNode != null)
          OgletFormField(
            fieldKey: const Key('name_field'),
            label: OgletContent.nameLabel,
            labelTop: DesignTokens.nameLabelTop,
            inputTop: DesignTokens.nameTop,
            placeholder: OgletContent.namePlaceholder,
            controller: nameController!,
            focusNode: nameFocusNode!,
            isError: nameError != null,
            errorMessage: nameError,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            autofillHints: const [AutofillHints.name],
            enabled: !isLoading && !isSuccess,
            onChanged: (val) {
              engine.lookAtField(0, val.length * 8.0);
            },
          ),

        // Primary Identifier Field (Email / Username) with scoped shake listener
        ListenableBuilder(
          listenable: engine,
          builder: (context, _) {
            return OgletFormField(
              fieldKey: const Key('identifier_field'),
              label: identifierLabel ?? _defaultIdentifierLabel(),
              labelTop: idLabelTop,
              inputTop: idInputTop,
              placeholder:
                  identifierPlaceholder ?? _defaultIdentifierPlaceholder(),
              controller: identifierController,
              focusNode: identifierFocusNode,
              isError: identifierError != null,
              errorMessage: identifierError,
              shakeX: engine.state.emailShakeX,
              showCheck: true,
              checkOpacity: isIdentifierValid ? 1.0 : 0.0,
              checkScale: isIdentifierValid ? 1.0 : 0.5,
              keyboardType: _identifierKeyboardType(),
              autofillHints: _identifierAutofillHints(),
              textInputAction: TextInputAction.next,
              enabled: !isLoading && !isSuccess,
              onChanged: (val) {
                engine.lookAtField(showNameField ? 1 : 0, val.length * 8.0);
              },
            );
          },
        ),

        // Password Label & Forgot Password Link Row
        if (onForgotPassword != null)
          Positioned(
            right: DesignTokens.fieldInset,
            top: passLabelTop - 12.0,
            child: GestureDetector(
              key: const Key('forgot_password_button'),
              onTap: (!isLoading && !isSuccess) ? onForgotPassword : null,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 12.0,
                ),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontFamily: DesignTokens.fontFamily,
                    fontSize: DesignTokens.labelSize,
                    fontWeight: DesignTokens.labelWeight,
                    color: DesignTokens.muted,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),

        // Password Field
        OgletFormField(
          fieldKey: const Key('password_field'),
          label: passwordLabel ?? OgletContent.passwordLabel,
          labelTop: passLabelTop,
          inputTop: passInputTop,
          placeholder: passwordPlaceholder ?? OgletContent.passwordPlaceholder,
          controller: passwordController,
          focusNode: passwordFocusNode,
          isPassword: true,
          obscureText: isPasswordObscured,
          onTogglePasswordVisibility: onTogglePasswordVisibility,
          isError: passwordError != null,
          errorMessage: passwordError,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          enabled: !isLoading && !isSuccess,
          onChanged: (val) {
            engine.lookAtField(showNameField ? 2 : 1, val.length * 8.0);
          },
          onSubmitted: (_) => onLoginPressed(),
        ),

        // Optional Password Strength Meter reactively listening to password keystrokes
        if (showPasswordStrength)
          ListenableBuilder(
            listenable: passwordController,
            builder: (context, _) {
              return PasswordStrengthMeter(
                top: meterTop,
                passwordDots: passwordController.text.length,
                maxDots: OgletContent.passwordLength,
              );
            },
          ),

        // Main Action Button (Log in / Create account) with scoped press & spinner listener
        ListenableBuilder(
          listenable: engine,
          builder: (context, _) {
            final state = engine.state;
            return SignupButton(
              isLoading: isLoading,
              isDone: isSuccess,
              enabled: !isLoading && !isSuccess,
              label: loginButtonText ?? OgletContent.login,
              loadingLabel:
                  loginButtonLoadingText ?? OgletContent.buttonLoading,
              doneLabel: loginButtonSuccessText ?? OgletContent.buttonDone,
              pressScale: state.buttonPressScale,
              spinnerAngle: state.spinnerAngle,
              onTap: () {
                engine.lookAtButton();
                engine.triggerButtonPress();
                onLoginPressed();
              },
            );
          },
        ),

        // Footer (e.g. "Don't have an account? Sign up" / "Already a member? Log in")
        Positioned(
          left: 0.0,
          right: 0.0,
          top: DesignTokens.memberTop,
          child: Center(
            child: GestureDetector(
              key: const Key('create_account_button'),
              onTap: (!isLoading && !isSuccess) ? onCreateAccount : null,
              behavior: HitTestBehavior.opaque,
              child: Text.rich(
                TextSpan(
                  text: '${footerPromptText ?? "Don't have an account?"} ',
                  style: const TextStyle(
                    fontFamily: DesignTokens.fontFamily,
                    fontSize: DesignTokens.memberSize,
                    fontWeight: DesignTokens.memberWeight,
                    color: DesignTokens.muted,
                    height: 1.0,
                  ),
                  children: [
                    TextSpan(
                      text: footerActionText ?? OgletContent.button,
                      style: const TextStyle(
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
        ),
      ],
    );
  }
}
