import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafi_login_template/rafi_login_template.dart';
import 'package:rafi_login_template/src/presentation/widgets/design_stage.dart';
import 'package:rafi_login_template/src/presentation/widgets/phone_frame.dart';

void main() {
  testWidgets(
    'RafiLoginScreen renders DesignStage, PhoneFrame, and core UI elements',
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

      expect(find.byType(DesignStage), findsOneWidget);
      expect(find.byType(PhoneFrame), findsOneWidget);
      expect(find.text(RafiLoginContent.time), findsOneWidget);
      expect(find.text(RafiLoginContent.title), findsOneWidget);
      expect(find.text(RafiLoginContent.nameLabel), findsOneWidget);
      expect(find.text(RafiLoginContent.emailLabel), findsOneWidget);
      expect(find.text(RafiLoginContent.passwordLabel), findsOneWidget);
      expect(find.textContaining(RafiLoginContent.login), findsOneWidget);
    },
  );

  group('Viewport scaling responsive test cases', () {
    final testSizes = [
      const Size(1080.0, 1080.0), // 1.0
      const Size(1440.0, 900.0), // 0.833
      const Size(2560.0, 1080.0), // 1.0
      const Size(390.0, 844.0), // ~0.78
      const Size(375.0, 667.0), // ~0.617
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

          expect(find.byType(DesignStage), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  });
}
