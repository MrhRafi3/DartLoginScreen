import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rafi_login_template/rafi_login_template.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RafiLoginExampleApp());
}

/// Host application demonstrating how to embed [RafiLoginScreen].
class RafiLoginExampleApp extends StatelessWidget {
  const RafiLoginExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rafi Login Template Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Outfit',
        scaffoldBackgroundColor: RafiDesignTokens.paper,
      ),
      home: const ExampleLoginPage(),
    );
  }
}

/// Example login page embedding [RafiLoginScreen] as an ordinary Flutter widget.
class ExampleLoginPage extends StatefulWidget {
  const ExampleLoginPage({super.key});

  @override
  State<ExampleLoginPage> createState() => _ExampleLoginPageState();
}

class _ExampleLoginPageState extends State<ExampleLoginPage> {
  bool _showPhoneFrame = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RafiDesignTokens.paper,
      appBar: AppBar(
        title: const Text('Rafi Login Template Demo'),
        backgroundColor: RafiDesignTokens.ink,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: _showPhoneFrame
                ? 'Switch to Embedded Mode'
                : 'Switch to Phone Mockup Mode',
            icon: Icon(_showPhoneFrame ? Icons.smartphone : Icons.crop_free),
            onPressed: () {
              setState(() {
                _showPhoneFrame = !_showPhoneFrame;
              });
            },
          ),
        ],
      ),
      body: RafiLoginScreen(
        showPhoneFrame: _showPhoneFrame,
        title: 'Welcome back',
        subtitle: "The crew will keep an eye on things",
        loginButtonText: 'Log in',
        // Mock authentication callback with simulated network latency
        onLogin: (credentials) async {
          // 1. Simulate network latency
          await Future<void>.delayed(const Duration(milliseconds: 1200));

          // 2. Demonstration error trigger: email containing 'error'
          if (credentials.identifier.toLowerCase().contains('error')) {
            return const AuthResult.failure(
              'Invalid credentials. (Hint: enter any email without "error")',
            );
          }

          // 3. Successful authentication
          return const AuthResult.success();
        },

        // Host navigation upon successful authentication celebration
        onAuthenticated: (credentials) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (context) => SampleHomePage(credentials: credentials),
            ),
          );
        },

        // Host handler for "Forgot password?" link
        onForgotPassword: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Host App: Forgot password route triggered!'),
              duration: Duration(seconds: 2),
            ),
          );
        },

        // Host handler for registration link
        onCreateAccount: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Host App: Create account route triggered!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}

/// Sample home page destination reached upon successful authentication.
class SampleHomePage extends StatelessWidget {
  final LoginCredentials credentials;

  const SampleHomePage({super.key, required this.credentials});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host App — Home Dashboard'),
        backgroundColor: RafiDesignTokens.ink,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: RafiDesignTokens.ok,
                size: 72.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Welcome, ${credentials.name ?? credentials.identifier}!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: RafiDesignTokens.ink,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Authenticated as: ${credentials.identifier}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: RafiDesignTokens.muted,
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: RafiDesignTokens.ink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 14.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (context) => const ExampleLoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
