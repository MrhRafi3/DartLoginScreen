import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafi_login_template/rafi_login_template.dart';

void main() {
  testWidgets(
    'RafiLoginScreen renders genuine full-screen UI and core UI elements directly',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RafiLoginScreen(showNameField: true)),
        ),
      );
      // Initial frame
      await tester.pump(const Duration(milliseconds: 50));

      // No fake iPhone status bar or fake time
      expect(find.text(RafiLoginContent.time), findsNothing);

      // Core login form UI elements
      expect(find.byType(RafiLoginScreen), findsOneWidget);
      expect(find.text(RafiLoginContent.title), findsOneWidget);
      expect(find.text(RafiLoginContent.nameLabel), findsOneWidget);
      expect(find.text(RafiLoginContent.emailLabel), findsOneWidget);
      expect(find.text(RafiLoginContent.passwordLabel), findsOneWidget);
      expect(find.textContaining(RafiLoginContent.login), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    },
  );

  group('Viewport scaling responsive test cases', () {
    final testSizes = [
      const Size(1080.0, 1080.0),
      const Size(1440.0, 900.0),
      const Size(2560.0, 1080.0),
      const Size(390.0, 844.0),
      const Size(375.0, 667.0),
      const Size(360.0, 640.0), // Small Android phone
    ];

    for (final size in testSizes) {
      testWidgets(
        'Renders properly without overflow on ${size.width}x${size.height}',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(
            const MaterialApp(home: Scaffold(body: RafiLoginScreen())),
          );
          await tester.pump(const Duration(milliseconds: 100));

          expect(find.byType(RafiLoginScreen), findsOneWidget);
          expect(find.byKey(const Key('login_button')), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  });

  testWidgets('Keyboard-open state adapts responsively without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390.0, 844.0);
    tester.view.devicePixelRatio = 1.0;
    // Simulate software keyboard occupying 300px
    tester.view.viewInsets = const FakeViewPadding(bottom: 300.0);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetViewInsets();
    });

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RafiLoginScreen())),
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byKey(const Key('identifier_field')), findsOneWidget);
    expect(find.byKey(const Key('password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
