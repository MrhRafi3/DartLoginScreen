import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oglet/app.dart';
import 'package:oglet/data/oglet_content.dart';
import 'package:oglet/presentation/widgets/design_stage.dart';
import 'package:oglet/presentation/widgets/phone_frame.dart';

void main() {
  testWidgets(
    'OgletApp renders DesignStage, PhoneFrame, and core UI elements',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080.0, 1080.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const OgletApp());
      // Initial frame
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(DesignStage), findsOneWidget);
      expect(find.byType(PhoneFrame), findsOneWidget);
      expect(find.text(OgletContent.time), findsOneWidget);
      expect(find.text(OgletContent.title), findsOneWidget);
      expect(find.text(OgletContent.nameLabel), findsOneWidget);
      expect(find.text(OgletContent.emailLabel), findsOneWidget);
      expect(find.text(OgletContent.passwordLabel), findsOneWidget);
      expect(find.textContaining(OgletContent.login), findsOneWidget);
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

          await tester.pumpWidget(const OgletApp());
          await tester.pump(const Duration(milliseconds: 100));

          expect(find.byType(DesignStage), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  });
}
