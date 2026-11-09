import 'dart:async';
import 'package:flutter/material.dart';

import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/data/oglet_content.dart';
import 'package:oglet/engine/oglet_animation_engine.dart';
import 'package:oglet/models/login_credentials.dart';
import 'package:oglet/presentation/widgets/design_stage.dart';
import 'package:oglet/presentation/widgets/oglet_login_form.dart';
import 'package:oglet/presentation/widgets/phone_frame.dart';

/// Production-ready, reusable Oglet authentication screen.
///
/// Converts the Oglet vector-animated sign-up demonstration into an interactive,
/// reusable login component with real text inputs, password visibility toggle,
/// inline validation, character reactivity, and pluggable authentication callbacks.
class OgletLoginScreen extends StatefulWidget {
  /// Authentication handler invoked when the user submits valid credentials.
  ///
  /// Can return an [AuthResult], complete normally on success, or throw an exception
  /// with a user-friendly error message on failure.
  final FutureOr<dynamic> Function(LoginCredentials credentials)? onLogin;

  /// Callback invoked when the user taps "Forgot password?".
  final VoidCallback? onForgotPassword;

  /// Callback invoked when the user taps the footer registration link.
  final VoidCallback? onCreateAccount;

  /// Callback invoked after successful authentication and celebration animation.
  final void Function(LoginCredentials credentials)? onAuthenticated;

  /// Format and validation mode for the primary identifier field.
  final OgletIdentifierType identifierType;

  /// Custom override for the identifier field label.
  final String? identifierLabel;

  /// Custom override for the identifier field placeholder.
  final String? identifierPlaceholder;

  /// Custom override for the password field label.
  final String? passwordLabel;

  /// Custom override for the password field placeholder.
  final String? passwordPlaceholder;

  /// Header title (defaults to "Welcome back" or "Join the crew").
  final String? title;

  /// Header subtitle (defaults to "They'll keep an eye on things").
  final String? subtitle;

  /// Main action button label (defaults to "Log in").
  final String? loginButtonText;

  /// Button label displayed while authentication is in progress.
  final String? loginButtonLoadingText;

  /// Button label displayed upon successful authentication.
  final String? loginButtonSuccessText;

  /// Footer prompt text (defaults to "Don't have an account?").
  final String? footerPromptText;

  /// Footer action text (defaults to "Sign up" or "Create account").
  final String? footerActionText;

  /// Custom validator for the identifier input.
  final String? Function(String? value)? identifierValidator;

  /// Custom validator for the password input.
  final String? Function(String? value)? passwordValidator;

  /// Optional externally managed controller for the identifier field.
  final TextEditingController? identifierController;

  /// Optional externally managed controller for the password field.
  final TextEditingController? passwordController;

  /// Optional externally managed focus node for the identifier field.
  final FocusNode? identifierFocusNode;

  /// Optional externally managed focus node for the password field.
  final FocusNode? passwordFocusNode;

  /// Whether to display the animated password strength bar.
  final bool showPasswordStrength;

  /// Whether to display an optional Name field above the identifier (3-field mode).
  final bool showNameField;

  /// Optional externally managed controller for the name field.
  final TextEditingController? nameController;

  /// Optional externally managed focus node for the name field.
  final FocusNode? nameFocusNode;

  /// Custom validator for the name input.
  final String? Function(String? value)? nameValidator;

  /// Whether to frame the login screen inside the Oglet phone mock-up and stage.
  final bool showPhoneFrame;

  const OgletLoginScreen({
    super.key,
    this.onLogin,
    this.onForgotPassword,
    this.onCreateAccount,
    this.onAuthenticated,
    this.identifierType = OgletIdentifierType.email,
    this.identifierLabel,
    this.identifierPlaceholder,
    this.passwordLabel,
    this.passwordPlaceholder,
    this.title,
    this.subtitle,
    this.loginButtonText,
    this.loginButtonLoadingText,
    this.loginButtonSuccessText,
    this.footerPromptText,
    this.footerActionText,
    this.identifierValidator,
    this.passwordValidator,
    this.identifierController,
    this.passwordController,
    this.identifierFocusNode,
    this.passwordFocusNode,
    this.showPasswordStrength = false,
    this.showNameField = false,
    this.nameController,
    this.nameFocusNode,
    this.nameValidator,
    this.showPhoneFrame = true,
  });

  @override
  State<OgletLoginScreen> createState() => _OgletLoginScreenState();
}

class _OgletLoginScreenState extends State<OgletLoginScreen>
    with SingleTickerProviderStateMixin {
  OgletAnimationEngine? _engine;
  bool? _lastReducedMotion;

  // Controllers & ownership flags
  late TextEditingController _identifierController;
  late bool _ownsIdentifierController;
  late FocusNode _identifierFocusNode;
  late bool _ownsIdentifierFocusNode;

  late TextEditingController _passwordController;
  late bool _ownsPasswordController;
  late FocusNode _passwordFocusNode;
  late bool _ownsPasswordFocusNode;

  TextEditingController? _nameController;
  bool _ownsNameController = false;
  FocusNode? _nameFocusNode;
  bool _ownsNameFocusNode = false;

  // Form State
  bool _isPasswordObscured = true;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _identifierError;
  String? _passwordError;
  String? _nameError;
  String? _authError;
  bool _isIdentifierValid = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    if (widget.identifierController != null) {
      _identifierController = widget.identifierController!;
      _ownsIdentifierController = false;
    } else {
      _identifierController = TextEditingController();
      _ownsIdentifierController = true;
    }

    if (widget.identifierFocusNode != null) {
      _identifierFocusNode = widget.identifierFocusNode!;
      _ownsIdentifierFocusNode = false;
    } else {
      _identifierFocusNode = FocusNode();
      _ownsIdentifierFocusNode = true;
    }

    if (widget.passwordController != null) {
      _passwordController = widget.passwordController!;
      _ownsPasswordController = false;
    } else {
      _passwordController = TextEditingController();
      _ownsPasswordController = true;
    }

    if (widget.passwordFocusNode != null) {
      _passwordFocusNode = widget.passwordFocusNode!;
      _ownsPasswordFocusNode = false;
    } else {
      _passwordFocusNode = FocusNode();
      _ownsPasswordFocusNode = true;
    }

    if (widget.showNameField) {
      if (widget.nameController != null) {
        _nameController = widget.nameController!;
        _ownsNameController = false;
      } else {
        _nameController = TextEditingController();
        _ownsNameController = true;
      }

      if (widget.nameFocusNode != null) {
        _nameFocusNode = widget.nameFocusNode!;
        _ownsNameFocusNode = false;
      } else {
        _nameFocusNode = FocusNode();
        _ownsNameFocusNode = true;
      }
    }

    // Attach listeners for character eye tracking and input validation
    _identifierFocusNode.addListener(_handleIdentifierFocusChange);
    _passwordFocusNode.addListener(_handlePasswordFocusChange);
    _identifierController.addListener(_handleIdentifierTextChange);
    _passwordController.addListener(_handlePasswordTextChange);

    _nameFocusNode?.addListener(_handleNameFocusChange);
  }

  void _handleIdentifierFocusChange() {
    if (_identifierFocusNode.hasFocus) {
      _engine?.lookAtField(widget.showNameField ? 1 : 0);
    } else if (!_passwordFocusNode.hasFocus &&
        !(_nameFocusNode?.hasFocus ?? false)) {
      _engine?.lookAtRest();
    }
  }

  void _handlePasswordFocusChange() {
    if (_passwordFocusNode.hasFocus) {
      _engine?.lookAtField(widget.showNameField ? 2 : 1);
    } else if (!_identifierFocusNode.hasFocus &&
        !(_nameFocusNode?.hasFocus ?? false)) {
      _engine?.lookAtRest();
    }
  }

  void _handleNameFocusChange() {
    if (_nameFocusNode?.hasFocus ?? false) {
      _engine?.lookAtField(0);
    } else if (!_identifierFocusNode.hasFocus && !_passwordFocusNode.hasFocus) {
      _engine?.lookAtRest();
    }
  }

  void _handleIdentifierTextChange() {
    final text = _identifierController.text.trim();
    final bool valid = _checkIdentifierValidity(text);

    if (_isIdentifierValid != valid) {
      setState(() {
        _isIdentifierValid = valid;
      });
      _engine?.setValid(valid);
    }

    if (_identifierError != null || _authError != null) {
      setState(() {
        _identifierError = null;
        _authError = null;
      });
      _engine?.clearError();
    }
  }

  void _handlePasswordTextChange() {
    if (_passwordError != null || _authError != null) {
      setState(() {
        _passwordError = null;
        _authError = null;
      });
      _engine?.clearError();
    }
  }

  bool _checkIdentifierValidity(String text) {
    if (text.isEmpty) return false;
    switch (widget.identifierType) {
      case OgletIdentifierType.email:
        return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
      case OgletIdentifierType.username:
        return text.length >= 3;
      case OgletIdentifierType.emailOrUsername:
        return text.length >= 3;
      case OgletIdentifierType.name:
        return text.isNotEmpty;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool reducedMotion = MediaQuery.disableAnimationsOf(context);

    if (_engine == null || _lastReducedMotion != reducedMotion) {
      _engine?.dispose();
      _lastReducedMotion = reducedMotion;
      _engine = OgletAnimationEngine(
        vsync: this,
        prefersReducedMotion: reducedMotion,
      );
    }
  }

  @override
  void didUpdateWidget(covariant OgletLoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.identifierController != oldWidget.identifierController) {
      _identifierController.removeListener(_handleIdentifierTextChange);
      if (_ownsIdentifierController) _identifierController.dispose();
      if (widget.identifierController != null) {
        _identifierController = widget.identifierController!;
        _ownsIdentifierController = false;
      } else {
        _identifierController = TextEditingController();
        _ownsIdentifierController = true;
      }
      _identifierController.addListener(_handleIdentifierTextChange);
    }

    if (widget.identifierFocusNode != oldWidget.identifierFocusNode) {
      _identifierFocusNode.removeListener(_handleIdentifierFocusChange);
      if (_ownsIdentifierFocusNode) _identifierFocusNode.dispose();
      if (widget.identifierFocusNode != null) {
        _identifierFocusNode = widget.identifierFocusNode!;
        _ownsIdentifierFocusNode = false;
      } else {
        _identifierFocusNode = FocusNode();
        _ownsIdentifierFocusNode = true;
      }
      _identifierFocusNode.addListener(_handleIdentifierFocusChange);
    }

    if (widget.passwordController != oldWidget.passwordController) {
      _passwordController.removeListener(_handlePasswordTextChange);
      if (_ownsPasswordController) _passwordController.dispose();
      if (widget.passwordController != null) {
        _passwordController = widget.passwordController!;
        _ownsPasswordController = false;
      } else {
        _passwordController = TextEditingController();
        _ownsPasswordController = true;
      }
      _passwordController.addListener(_handlePasswordTextChange);
    }

    if (widget.passwordFocusNode != oldWidget.passwordFocusNode) {
      _passwordFocusNode.removeListener(_handlePasswordFocusChange);
      if (_ownsPasswordFocusNode) _passwordFocusNode.dispose();
      if (widget.passwordFocusNode != null) {
        _passwordFocusNode = widget.passwordFocusNode!;
        _ownsPasswordFocusNode = false;
      } else {
        _passwordFocusNode = FocusNode();
        _ownsPasswordFocusNode = true;
      }
      _passwordFocusNode.addListener(_handlePasswordFocusChange);
    }

    if (widget.showNameField != oldWidget.showNameField ||
        widget.nameController != oldWidget.nameController ||
        widget.nameFocusNode != oldWidget.nameFocusNode) {
      _nameFocusNode?.removeListener(_handleNameFocusChange);
      if (_ownsNameController) _nameController?.dispose();
      if (_ownsNameFocusNode) _nameFocusNode?.dispose();

      if (widget.showNameField) {
        if (widget.nameController != null) {
          _nameController = widget.nameController!;
          _ownsNameController = false;
        } else {
          _nameController = TextEditingController();
          _ownsNameController = true;
        }

        if (widget.nameFocusNode != null) {
          _nameFocusNode = widget.nameFocusNode!;
          _ownsNameFocusNode = false;
        } else {
          _nameFocusNode = FocusNode();
          _ownsNameFocusNode = true;
        }
        _nameFocusNode!.addListener(_handleNameFocusChange);
      } else {
        _nameController = null;
        _ownsNameController = false;
        _nameFocusNode = null;
        _ownsNameFocusNode = false;
      }
    }
  }

  @override
  void dispose() {
    _identifierFocusNode.removeListener(_handleIdentifierFocusChange);
    _passwordFocusNode.removeListener(_handlePasswordFocusChange);
    _identifierController.removeListener(_handleIdentifierTextChange);
    _passwordController.removeListener(_handlePasswordTextChange);
    _nameFocusNode?.removeListener(_handleNameFocusChange);

    if (_ownsIdentifierController) _identifierController.dispose();
    if (_ownsIdentifierFocusNode) _identifierFocusNode.dispose();
    if (_ownsPasswordController) _passwordController.dispose();
    if (_ownsPasswordFocusNode) _passwordFocusNode.dispose();
    if (_ownsNameController) _nameController?.dispose();
    if (_ownsNameFocusNode) _nameFocusNode?.dispose();

    _engine?.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  Future<void> _handleSubmit() async {
    // Prevent duplicate submissions while in-flight or already succeeded
    if (_isLoading || _isSuccess) return;

    final String identifier = _identifierController.text.trim();
    final String password = _passwordController.text;
    final String? name = _nameController?.text.trim();

    // 1. Validation
    String? idErr;
    if (widget.identifierValidator != null) {
      idErr = widget.identifierValidator!(identifier);
    } else {
      if (identifier.isEmpty) {
        idErr =
            'Please enter your ${widget.identifierLabel ?? _defaultIdentifierLabelName()}';
      } else if (widget.identifierType == OgletIdentifierType.email &&
          !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(identifier)) {
        idErr = OgletContent.error;
      } else if (widget.identifierType == OgletIdentifierType.username &&
          identifier.length < 3) {
        idErr = 'Username must be at least 3 characters';
      }
    }

    String? passErr;
    if (widget.passwordValidator != null) {
      passErr = widget.passwordValidator!(password);
    } else {
      if (password.isEmpty) {
        passErr = 'Please enter your password';
      } else if (password.length < 8) {
        passErr = 'Password must be at least 8 characters';
      }
    }

    String? nameErr;
    if (widget.showNameField) {
      if (widget.nameValidator != null) {
        nameErr = widget.nameValidator!(name);
      } else if (name == null || name.isEmpty) {
        nameErr = 'Please enter your name';
      }
    }

    if (idErr != null || passErr != null || nameErr != null) {
      setState(() {
        _identifierError = idErr;
        _passwordError = passErr;
        _nameError = nameErr;
        _authError = null;
      });
      _engine?.triggerError();
      return;
    }

    // 2. Begin Authentication Request
    setState(() {
      _isLoading = true;
      _authError = null;
      _identifierError = null;
      _passwordError = null;
      _nameError = null;
    });
    _engine?.setLoading(true);

    final credentials = LoginCredentials(
      identifier: identifier,
      password: password,
      name: name,
    );

    try {
      if (widget.onLogin != null) {
        final result = await widget.onLogin!(credentials);

        if (!mounted) return;

        if (result is AuthResult) {
          if (!result.isSuccess) {
            _handleAuthFailure(result.errorMessage ?? 'Authentication failed');
            return;
          }
        }
      }

      // Success
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
      _engine?.setLoading(false);
      _engine?.triggerSuccess();

      widget.onAuthenticated?.call(credentials);
    } catch (error) {
      if (!mounted) return;
      final String message = error is Exception
          ? error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')
          : error.toString();
      _handleAuthFailure(message);
    }
  }

  void _handleAuthFailure(String message) {
    setState(() {
      _isLoading = false;
      _authError = message;
    });
    _engine?.setLoading(false);
    _engine?.triggerError();
  }

  String _defaultIdentifierLabelName() {
    switch (widget.identifierType) {
      case OgletIdentifierType.email:
        return 'email';
      case OgletIdentifierType.username:
        return 'username';
      case OgletIdentifierType.emailOrUsername:
        return 'email or username';
      case OgletIdentifierType.name:
        return 'name';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_engine == null) {
      return const SizedBox.shrink();
    }

    final Widget formWidget = OgletLoginForm(
      engine: _engine!,
      identifierController: _identifierController,
      identifierFocusNode: _identifierFocusNode,
      identifierType: widget.identifierType,
      identifierLabel: widget.identifierLabel,
      identifierPlaceholder: widget.identifierPlaceholder,
      identifierError: _identifierError,
      isIdentifierValid: _isIdentifierValid,
      passwordController: _passwordController,
      passwordFocusNode: _passwordFocusNode,
      passwordLabel: widget.passwordLabel,
      passwordPlaceholder: widget.passwordPlaceholder,
      passwordError: _passwordError,
      isPasswordObscured: _isPasswordObscured,
      onTogglePasswordVisibility: _togglePasswordVisibility,
      showNameField: widget.showNameField,
      nameController: _nameController,
      nameFocusNode: _nameFocusNode,
      nameError: _nameError,
      showPasswordStrength: widget.showPasswordStrength,
      title: widget.title,
      subtitle: widget.subtitle,
      authError: _authError,
      isSuccess: _isSuccess,
      isLoading: _isLoading,
      loginButtonText: widget.loginButtonText,
      loginButtonLoadingText: widget.loginButtonLoadingText,
      loginButtonSuccessText: widget.loginButtonSuccessText,
      onLoginPressed: _handleSubmit,
      onForgotPassword: widget.onForgotPassword,
      onCreateAccount: widget.onCreateAccount,
      footerPromptText: widget.footerPromptText,
      footerActionText: widget.footerActionText,
    );

    if (!widget.showPhoneFrame) {
      return Container(
        color: DesignTokens.screen,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: DesignTokens.phoneWidth,
                height: DesignTokens.phoneHeight,
                child: formWidget,
              ),
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: OgletContent.description,
      container: true,
      child: DesignStage(
        child: PhoneFrame(engine: _engine!, form: formWidget),
      ),
    );
  }
}
