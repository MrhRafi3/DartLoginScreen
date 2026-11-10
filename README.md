# Rafi Login Template

A professional, personal-branded, reusable Flutter UI package featuring interactive vector-animated characters with physics-driven googly eyes and fluid spring animations.

`rafi_login_template` is designed to be installed into any Flutter application and embedded as a standard widget, leaving full control over routing, themes, authentication backends, and state handling to the host application.

---

## Features

- **Five Animated Vector Characters**: Fully custom-drawn with `CustomPainter` and organic Bézier curves (**Cookie**, **Bean**, **Sun**, **Wobble**, and **Pebble**).
- **Physics-Driven Eye Rigging**: Real-time gaze tracking that follows user typing and focus targets with natural spring mechanics, pupil dilation, and blinking.
- **Real User Inputs**: Clean text input fields with keyboard actions, focus nodes, real-time validation, and password visibility toggle.
- **Embedded & Mockup Modes**:
  - `showPhoneFrame: true` (default): Renders within an iconic phone mockup stage with dynamic island and status bar—ideal for tablet, desktop, and web showcases.
  - `showPhoneFrame: false`: Renders as an edge-to-edge responsive canvas with all 5 characters, sparkles, and reactive form elements—ideal for direct embedding into existing mobile application views.
- **Pluggable & Typed Authentication**: Strongly typed `LoginCredentials` delivered to your async `onLogin` callback returning an `AuthResult`.
- **Security First**: Automatically masks passwords (`[PROTECTED]`) in `toString()` to prevent credential leakage in logs or crash reporting tools.
- **Bundled Typography**: Bundles the modern **Outfit** font family directly within the package, ensuring identical visual fidelity on all target platforms.
- **Full Host App Control**: Zero nested `MaterialApp` or `runApp()` calls. Works with standard Flutter navigation, GoRouter, CupertinoApp, and custom app shells.

---

## Installation

### Local Path Dependency

Add `rafi_login_template` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  rafi_login_template:
    path: ../rafi_login_template
```

### Git Dependency

To install directly from a private or public Git repository:

```yaml
dependencies:
  flutter:
    sdk: flutter

  rafi_login_template:
    git:
      url: https://github.com/MrhRafi3/DartLoginScreen.git
      ref: main
```

Run:

```bash
flutter pub get
```

---

## Quick Start

Import the package:

```dart
import 'package:flutter/material.dart';
import 'package:rafi_login_template/rafi_login_template.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: RafiLoginScreen(
          title: 'Welcome back',
          subtitle: "The crew will keep an eye on things",
          loginButtonText: 'Log in',
          onLogin: (credentials) async {
            // Call your actual authentication service here
            final bool success = await myAuthService.login(
              credentials.identifier,
              credentials.password,
            );

            if (!success) {
              return const AuthResult.failure('Invalid email or password');
            }
            return const AuthResult.success();
          },
          onAuthenticated: (credentials) {
            // Navigate to your main application dashboard
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          },
          onForgotPassword: () {
            // Navigate to forgot password screen
          },
          onCreateAccount: () {
            // Navigate to registration screen
          },
        ),
      ),
    );
  }
}
```

---

## Embedding Modes

`RafiLoginScreen` is a standard Flutter widget that can be placed inside any screen layout:

### 1. Presentation Mode (Phone Mockup)

By default (`showPhoneFrame: true`), the login widget renders inside a phone frame on a stage with status bar, dynamic island, and rounded bezel shadows.

```dart
RafiLoginScreen(
  showPhoneFrame: true,
  onLogin: (credentials) async { ... },
)
```

### 2. Direct Mobile Embedded Mode

When embedding directly inside a mobile app page (e.g. inside an existing `Scaffold`), set `showPhoneFrame: false`. This removes the outer mockup bezel and status bar while retaining all five reactive characters, background sparkles, and responsive form components:

```dart
RafiLoginScreen(
  showPhoneFrame: false,
  onLogin: (credentials) async { ... },
)
```

---

## Custom Logo & Branding

You can supply an optional custom logo widget to display above the form title:

```dart
RafiLoginScreen(
  logo: Image.asset(
    'assets/images/my_brand_logo.png',
    width: 48,
    height: 48,
  ),
  title: 'Sign in to ACME',
  onLogin: (credentials) async { ... },
)
```

---

## Identifier Modes

Configure the identifier input to accept emails, usernames, names, or both:

```dart
// Username mode
RafiLoginScreen(
  identifierType: RafiIdentifierType.username,
  identifierLabel: 'Username',
  identifierPlaceholder: 'Enter your username',
  onLogin: (credentials) async { ... },
)

// Email or Username flexible mode
RafiLoginScreen(
  identifierType: RafiIdentifierType.emailOrUsername,
  onLogin: (credentials) async { ... },
)

// 3-Field mode (Name + Email + Password)
RafiLoginScreen(
  showNameField: true,
  onLogin: (credentials) async {
    print('Name: ${credentials.name}');
    print('Email: ${credentials.identifier}');
    return const AuthResult.success();
  },
)
```

---

## API Reference

### `RafiLoginScreen`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `onLogin` | `FutureOr<dynamic> Function(LoginCredentials)?` | `null` | Primary authentication callback invoked when user submits valid credentials. Return `AuthResult.success()`, `AuthResult.failure('error')`, or throw an `Exception`. |
| `onAuthenticated` | `void Function(LoginCredentials)?` | `null` | Invoked after successful authentication and character celebration animation. |
| `onForgotPassword` | `VoidCallback?` | `null` | Callback when tapping "Forgot password?". |
| `onCreateAccount` | `VoidCallback?` | `null` | Callback when tapping footer registration link. |
| `identifierType` | `RafiIdentifierType` | `email` | Mode for identifier: `email`, `username`, `emailOrUsername`, or `name`. |
| `identifierLabel` | `String?` | Auto | Custom label for primary identifier field. |
| `identifierPlaceholder` | `String?` | Auto | Custom placeholder for primary identifier field. |
| `passwordLabel` | `String?` | `'Password'` | Custom label for password field. |
| `passwordPlaceholder` | `String?` | `'8+ characters'` | Custom placeholder for password field. |
| `title` | `String?` | `'Join the crew'` | Main title header text. |
| `subtitle` | `String?` | `"They'll keep an eye on things"` | Subtitle description text. |
| `loginButtonText` | `String?` | `'Log in'` | Label for the submit button in resting state. |
| `loginButtonLoadingText` | `String?` | `'Signing in...'` | Label for submit button during in-flight auth. |
| `loginButtonSuccessText` | `String?` | `'Welcome aboard'` | Label for submit button upon authentication success. |
| `footerPromptText` | `String?` | `"Don't have an account?"` | Footer question/prompt text. |
| `footerActionText` | `String?` | `'Sign up'` | Footer clickable link text. |
| `logo` | `Widget?` | `null` | Optional brand logo or icon widget placed above the title. |
| `showPhoneFrame` | `bool` | `true` | Whether to render inside the presentation phone mockup (`true`) or direct canvas (`false`). |
| `showPasswordStrength` | `bool` | `false` | Whether to display the animated password strength bar. |
| `showNameField` | `bool` | `false` | Whether to display an optional Name field above the identifier (3-field mode). |
| `identifierController` | `TextEditingController?` | Managed | Optional externally owned controller for identifier. |
| `passwordController` | `TextEditingController?` | Managed | Optional externally owned controller for password. |
| `nameController` | `TextEditingController?` | Managed | Optional externally owned controller for name. |
| `identifierValidator` | `String? Function(String?)?` | Built-in | Custom validation function for identifier. |
| `passwordValidator` | `String? Function(String?)?` | Built-in | Custom validation function for password. |

---

## Example Application

A fully runnable example is included in the `example/` folder. It demonstrates:
- Clean package consumption via `package:rafi_login_template/rafi_login_template.dart`
- Mock authentication with latency and error handling
- Navigation to a dashboard using host `Navigator`
- Toggling between mockup and embedded modes

To run the example:

```bash
cd example
flutter run
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.
