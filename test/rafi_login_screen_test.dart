import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rafi_login_template/rafi_login_template.dart';

void main() {
  Widget buildTestableScreen(
    Widget screen, {
    Size size = const Size(1080.0, 1080.0),
  }) {
    return MaterialApp(
      theme: ThemeData(fontFamily: RafiDesignTokens.fontFamily),
      home: Scaffold(body: screen),
    );
  }

  group('RafiLoginScreen Production Unit & Widget Tests', () {
    // 1. Empty form validation
    testWidgets(
      '1. Empty form validation displays error and prevents submission',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080.0, 1080.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        bool loginCalled = false;
        await tester.pumpWidget(
          buildTestableScreen(
            RafiLoginScreen(
              onLogin: (credentials) {
                loginCalled = true;
                return const AuthResult.success();
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));

        // Attempt to submit empty form
        final buttonFinder = find.byKey(const Key('login_button'));
        expect(buttonFinder, findsOneWidget);
        await tester.tap(buttonFinder);
        await tester.pump();

        // Expect identifier error message
        expect(find.textContaining('Please enter your email'), findsOneWidget);
        expect(loginCalled, false);
      },
    );

    // 2. Valid identifier and password
    testWidgets('2. Valid identifier and password clears errors and submits', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool loginCalled = false;
      await tester.pumpWidget(
        buildTestableScreen(
          RafiLoginScreen(
            onLogin: (credentials) {
              loginCalled = true;
              return const AuthResult.success();
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      await tester.enterText(
        find.byKey(const Key('identifier_field')),
        'alex@studio.io',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump(const Duration(milliseconds: 100));

      expect(loginCalled, true);
    });

    // 3. Password visibility toggle
    testWidgets('3. Password visibility toggle shows and hides password text', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableScreen(const RafiLoginScreen()));
      await tester.pump(const Duration(milliseconds: 50));

      final passwordFieldFinder = find.byKey(const Key('password_field'));
      TextField passField = tester.widget<TextField>(passwordFieldFinder);
      expect(passField.obscureText, true);

      final toggleFinder = find.byKey(const Key('password_visibility_toggle'));
      expect(toggleFinder, findsOneWidget);

      // Tap to reveal
      await tester.tap(toggleFinder);
      await tester.pump();

      passField = tester.widget<TextField>(passwordFieldFinder);
      expect(passField.obscureText, false);

      // Tap again to hide
      await tester.tap(toggleFinder);
      await tester.pump();

      passField = tester.widget<TextField>(passwordFieldFinder);
      expect(passField.obscureText, true);
    });

    // 4. User-entered text
    testWidgets('4. User-entered text updates form controllers correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableScreen(const RafiLoginScreen()));
      await tester.pump(const Duration(milliseconds: 50));

      await tester.enterText(
        find.byKey(const Key('identifier_field')),
        'user@domain.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'securePass99',
      );
      await tester.pump();

      final idField = tester.widget<TextField>(
        find.byKey(const Key('identifier_field')),
      );
      final passField = tester.widget<TextField>(
        find.byKey(const Key('password_field')),
      );

      expect(idField.controller!.text, 'user@domain.com');
      expect(passField.controller!.text, 'securePass99');
    });

    // 5. Login callback invocation
    testWidgets('5. Login callback invocation is triggered upon submission', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      int invocationCount = 0;
      await tester.pumpWidget(
        buildTestableScreen(
          RafiLoginScreen(
            onLogin: (credentials) {
              invocationCount++;
              return const AuthResult.success();
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      await tester.enterText(
        find.byKey(const Key('identifier_field')),
        'user@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'validpassword1',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump(const Duration(milliseconds: 100));

      expect(invocationCount, 1);
    });

    // 6. Correct credentials passed to callback
    testWidgets(
      '6. Correct credentials model passed to callback with password protected in logs',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080.0, 1080.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        LoginCredentials? capturedCredentials;
        await tester.pumpWidget(
          buildTestableScreen(
            RafiLoginScreen(
              onLogin: (credentials) {
                capturedCredentials = credentials;
                return const AuthResult.success();
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));

        await tester.enterText(
          find.byKey(const Key('identifier_field')),
          'mira@studio.io',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'TopSecretPass!',
        );
        await tester.pump();

        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pump(const Duration(milliseconds: 100));

        expect(capturedCredentials, isNotNull);
        expect(capturedCredentials!.identifier, 'mira@studio.io');
        expect(capturedCredentials!.password, 'TopSecretPass!');

        // Verify toString() shields the password from logs
        final String stringRepresentation = capturedCredentials.toString();
        expect(stringRepresentation, contains('[PROTECTED]'));
        expect(stringRepresentation.contains('TopSecretPass!'), false);
      },
    );

    // 7. Loading state
    testWidgets('7. Loading state reflects in-flight authentication request', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final Completer<AuthResult> completer = Completer<AuthResult>();
      await tester.pumpWidget(
        buildTestableScreen(
          RafiLoginScreen(
            loginButtonLoadingText: 'Authenticating...',
            onLogin: (credentials) => completer.future,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      await tester.enterText(
        find.byKey(const Key('identifier_field')),
        'test@test.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump(); // Start async request

      // In loading state
      expect(find.text('Authenticating...'), findsOneWidget);

      // Finish request
      completer.complete(const AuthResult.success());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text(RafiLoginContent.buttonDone), findsOneWidget);
    });

    // 8. Duplicate submission prevention
    testWidgets(
      '8. Duplicate submission prevention ignores rapid taps while loading',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080.0, 1080.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        int requestCount = 0;
        final Completer<AuthResult> completer = Completer<AuthResult>();

        await tester.pumpWidget(
          buildTestableScreen(
            RafiLoginScreen(
              onLogin: (credentials) {
                requestCount++;
                return completer.future;
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));

        await tester.enterText(
          find.byKey(const Key('identifier_field')),
          'single@call.io',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'securePass888',
        );
        await tester.pump();

        // Rapidly tap the button multiple times
        final buttonFinder = find.byKey(const Key('login_button'));
        await tester.tap(buttonFinder);
        await tester.pump();
        await tester.tap(buttonFinder);
        await tester.pump();
        await tester.tap(buttonFinder);
        await tester.pump();

        expect(requestCount, 1);

        completer.complete(const AuthResult.success());
        await tester.pump(const Duration(milliseconds: 100));

        expect(requestCount, 1);
      },
    );

    // 9. Authentication failure
    testWidgets(
      '9. Authentication failure displays message and preserves identifier',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080.0, 1080.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          buildTestableScreen(
            RafiLoginScreen(
              onLogin: (credentials) {
                return const AuthResult.failure('Invalid email or password.');
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));

        await tester.enterText(
          find.byKey(const Key('identifier_field')),
          'wrong@creds.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'wrongpass',
        );
        await tester.pump();

        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pump(const Duration(milliseconds: 100));

        // Verify failure error message is displayed
        expect(find.text('Invalid email or password.'), findsOneWidget);

        // Verify entered identifier is preserved
        final idField = tester.widget<TextField>(
          find.byKey(const Key('identifier_field')),
        );
        expect(idField.controller!.text, 'wrong@creds.com');
      },
    );

    // 10. Authentication success
    testWidgets(
      '10. Authentication success displays celebration and calls onAuthenticated',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080.0, 1080.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        bool onAuthenticatedCalled = false;
        await tester.pumpWidget(
          buildTestableScreen(
            RafiLoginScreen(
              onLogin: (credentials) => const AuthResult.success(),
              onAuthenticated: (credentials) {
                onAuthenticatedCalled = true;
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));

        await tester.enterText(
          find.byKey(const Key('identifier_field')),
          'happy@crew.io',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'greatpassword1',
        );
        await tester.pump();

        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pump(const Duration(milliseconds: 100));

        expect(onAuthenticatedCalled, true);
        expect(find.text(RafiLoginContent.buttonDone), findsOneWidget);
        expect(find.text(RafiLoginContent.subtitleDone), findsOneWidget);
      },
    );

    // 11. Forgot password callback
    testWidgets('11. Forgot password callback is invoked on tap', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool forgotTapped = false;
      await tester.pumpWidget(
        buildTestableScreen(
          RafiLoginScreen(
            onForgotPassword: () {
              forgotTapped = true;
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      final forgotFinder = find.byKey(const Key('forgot_password_button'));
      expect(forgotFinder, findsOneWidget);

      await tester.tap(forgotFinder);
      await tester.pump(const Duration(milliseconds: 100));

      expect(forgotTapped, true);
    });

    // 12. Create-account callback
    testWidgets('12. Create-account callback is invoked on tap', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool createTapped = false;
      await tester.pumpWidget(
        buildTestableScreen(
          RafiLoginScreen(
            onCreateAccount: () {
              createTapped = true;
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      final createFinder = find.byKey(const Key('create_account_button'));
      expect(createFinder, findsOneWidget);

      await tester.tap(createFinder);
      await tester.pump(const Duration(milliseconds: 100));

      expect(createTapped, true);
    });

    // 13. Controller lifecycle
    testWidgets(
      '13. Controller lifecycle safely retains externally provided controllers',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080.0, 1080.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        final externalIdController = TextEditingController(
          text: 'init@external.com',
        );
        final externalPassController = TextEditingController(
          text: 'externalPass1',
        );
        final externalIdFocusNode = FocusNode();
        final externalPassFocusNode = FocusNode();

        addTearDown(() {
          externalIdController.dispose();
          externalPassController.dispose();
          externalIdFocusNode.dispose();
          externalPassFocusNode.dispose();
        });

        // Mount widget with external controllers
        await tester.pumpWidget(
          buildTestableScreen(
            RafiLoginScreen(
              identifierController: externalIdController,
              passwordController: externalPassController,
              identifierFocusNode: externalIdFocusNode,
              passwordFocusNode: externalPassFocusNode,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));

        expect(externalIdController.text, 'init@external.com');

        // Unmount the screen
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: SizedBox.shrink())),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Externally owned controllers must NOT be disposed and remain usable
        expect(externalIdController.text, 'init@external.com');
        expect(externalPassController.text, 'externalPass1');
        expect(externalIdFocusNode.hasFocus, false);
      },
    );

    testWidgets(
      '13b. Controller lifecycle handles dynamically updated external controllers',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080.0, 1080.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        final controller1 = TextEditingController(text: 'first@test.com');
        final controller2 = TextEditingController(text: 'second@test.com');
        addTearDown(() {
          controller1.dispose();
          controller2.dispose();
        });

        await tester.pumpWidget(
          buildTestableScreen(
            RafiLoginScreen(identifierController: controller1),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('first@test.com'), findsOneWidget);

        // Rebuild with swapped controller
        await tester.pumpWidget(
          buildTestableScreen(
            RafiLoginScreen(identifierController: controller2),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('second@test.com'), findsOneWidget);
      },
    );

    // 14. Responsive layouts
    group(
      '14. Responsive layouts render without overflow across device sizes',
      () {
        final testSizes = [
          const Size(360.0, 640.0), // Small Android Phone
          const Size(375.0, 667.0), // Mobile SE
          const Size(390.0, 844.0), // Mobile Modern
          const Size(412.0, 915.0), // Tall Modern Android
          const Size(1080.0, 1080.0), // Square Artboard
          const Size(1440.0, 900.0), // Desktop / Widescreen
        ];

        for (final size in testSizes) {
          testWidgets(
            'Responsive direct render on ${size.width}x${size.height}',
            (WidgetTester tester) async {
              tester.view.physicalSize = size;
              tester.view.devicePixelRatio = 1.0;
              addTearDown(tester.view.resetPhysicalSize);

              await tester.pumpWidget(
                buildTestableScreen(const RafiLoginScreen()),
              );
              await tester.pump(const Duration(milliseconds: 50));

              expect(find.byType(RafiLoginScreen), findsOneWidget);
              expect(find.byKey(const Key('login_button')), findsOneWidget);
              expect(find.byKey(const Key('identifier_field')), findsOneWidget);
              expect(find.byKey(const Key('password_field')), findsOneWidget);
              expect(tester.takeException(), isNull);
            },
          );
        }

        testWidgets(
          'Keyboard-open state adapts responsively without overflow',
          (WidgetTester tester) async {
            tester.view.physicalSize = const Size(390.0, 844.0);
            tester.view.devicePixelRatio = 1.0;
            tester.view.viewInsets = const FakeViewPadding(bottom: 300.0);
            addTearDown(() {
              tester.view.resetPhysicalSize();
              tester.view.resetViewInsets();
            });

            await tester.pumpWidget(
              buildTestableScreen(const RafiLoginScreen()),
            );
            await tester.pump(const Duration(milliseconds: 50));

            expect(find.byKey(const Key('identifier_field')), findsOneWidget);
            expect(find.byKey(const Key('password_field')), findsOneWidget);
            expect(find.byKey(const Key('login_button')), findsOneWidget);
            expect(tester.takeException(), isNull);
          },
        );

        testWidgets('Larger text scaling renders without RenderFlex overflow', (
          WidgetTester tester,
        ) async {
          tester.view.physicalSize = const Size(390.0, 844.0);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(fontFamily: RafiDesignTokens.fontFamily),
              home: const MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
                child: Scaffold(body: RafiLoginScreen()),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 50));

          expect(find.byKey(const Key('identifier_field')), findsOneWidget);
          expect(find.byKey(const Key('password_field')), findsOneWidget);
          expect(find.byKey(const Key('login_button')), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      },
    );

    // Additional test: Configurable identifier modes
    testWidgets(
      'Configurable identifier modes (username, name, emailOrUsername)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080.0, 1080.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          buildTestableScreen(
            const RafiLoginScreen(identifierType: RafiIdentifierType.username),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));

        expect(find.text('Username'), findsOneWidget);
        expect(find.text('your_username'), findsOneWidget);
      },
    );

    // Additional test: 3-field mode with optional Name field
    testWidgets('3-field mode with optional Name field validates and submits', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      LoginCredentials? captured;
      await tester.pumpWidget(
        buildTestableScreen(
          RafiLoginScreen(
            showNameField: true,
            onLogin: (credentials) {
              captured = credentials;
              return const AuthResult.success();
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byKey(const Key('name_field')), findsOneWidget);

      await tester.enterText(find.byKey(const Key('name_field')), 'Mira');
      await tester.enterText(
        find.byKey(const Key('identifier_field')),
        'mira@studio.io',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        '8pluscharacters',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump(const Duration(milliseconds: 100));

      expect(captured, isNotNull);
      expect(captured!.name, 'Mira');
      expect(captured!.identifier, 'mira@studio.io');
    });

    testWidgets('Custom logo widget renders when provided', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableScreen(
          const RafiLoginScreen(
            logo: Icon(Icons.star, key: Key('custom_logo_icon')),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byKey(const Key('custom_logo_icon')), findsOneWidget);
    });

    testWidgets(
      'RafiLoginScreen renders genuine mobile screen without nested phone mockup',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390.0, 844.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableScreen(const RafiLoginScreen()));
        await tester.pump(const Duration(milliseconds: 50));

        // Fake status bar with 9:41 time should NOT be present
        expect(find.text(RafiLoginContent.time), findsNothing);

        // Core form elements and characters are rendered
        expect(find.byKey(const Key('login_button')), findsOneWidget);
        expect(find.byKey(const Key('identifier_field')), findsOneWidget);
        expect(find.byKey(const Key('password_field')), findsOneWidget);
      },
    );

    test('RafiDesignTokens defines bundled Outfit font package', () {
      expect(RafiDesignTokens.fontFamily, 'Outfit');
      expect(RafiDesignTokens.fontPackage, 'rafi_login_template');
    });
  });
}
