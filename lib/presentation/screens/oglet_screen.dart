import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:oglet/data/oglet_content.dart';
import 'package:oglet/models/login_credentials.dart';
import 'package:oglet/presentation/screens/oglet_login_screen.dart';

/// Default screen presenting the interactive [OgletLoginScreen] with demonstration
/// authentication callbacks.
class OgletScreen extends StatelessWidget {
  final bool showNameField;

  const OgletScreen({super.key, this.showNameField = true});

  @override
  Widget build(BuildContext context) {
    return OgletLoginScreen(
      showNameField: showNameField,
      title: OgletContent.title,
      onLogin: (credentials) async {
        // DEMONSTRATION ONLY: Mock authentication simulating network roundtrip
        await Future<void>.delayed(const Duration(milliseconds: 1200));

        // Accept any email containing "error" as a failure trigger for testing/demo
        if (credentials.identifier.contains('error')) {
          return const AuthResult.failure(
            'Invalid credentials. Please try again.',
          );
        }

        // Accept any valid email/password
        return const AuthResult.success();
      },
      onForgotPassword: () {
        // Host application navigates to forgot password screen
      },
      onCreateAccount: () {
        // Host application navigates to registration screen
      },
      onAuthenticated: (credentials) {
        // Host application proceeds after celebration
      },
    );
  }
}
