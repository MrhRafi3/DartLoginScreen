import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:rafi_login_template/rafi_login_template.dart';

void main() {
  testWidgets('Example app embeds RafiLoginScreen and renders properly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080.0, 1080.0);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RafiLoginExampleApp());
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(RafiLoginScreen), findsOneWidget);
    expect(find.text('Rafi Login Template Demo'), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);
  });

  testWidgets('Example app handles mock login failure with error message', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080.0, 1080.0);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RafiLoginExampleApp());
    await tester.pump(const Duration(milliseconds: 50));

    await tester.enterText(
      find.byKey(const Key('identifier_field')),
      'error_user@test.com',
    );
    await tester.enterText(
      find.byKey(const Key('password_field')),
      'password123',
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump(const Duration(milliseconds: 50));

    // Advance mock timer
    await tester.pump(const Duration(milliseconds: 1300));

    expect(find.textContaining('Invalid credentials'), findsOneWidget);
  });

  testWidgets('Example app navigates to SampleHomePage upon valid login', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080.0, 1080.0);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RafiLoginExampleApp());
    await tester.pump(const Duration(milliseconds: 50));

    await tester.enterText(
      find.byKey(const Key('identifier_field')),
      'rafi@domain.com',
    );
    await tester.enterText(
      find.byKey(const Key('password_field')),
      'validPass123',
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump(const Duration(milliseconds: 50));

    // Advance mock timer
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    expect(find.byType(SampleHomePage), findsOneWidget);
    expect(find.text('Authenticated as: rafi@domain.com'), findsOneWidget);
  });
}
