// Basic smoke test for the HealthCare AI app.
//
// The default Flutter template test references a counter app (`MyApp`,
// tapping a '+' icon). This app has neither — it opens on SplashScreen,
// so the test below just verifies the splash renders its key content.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:health_care/main.dart';

void main() {
  testWidgets('Splash screen shows app name and tagline',
          (WidgetTester tester) async {
        // ProviderScope is required since the app uses Riverpod.
        await tester.pumpWidget(
          const ProviderScope(
            child: HealthCareApp(),
          ),
        );

        // Let the entrance animations run a frame.
        await tester.pump();

        expect(find.text('HealthCare AI'), findsOneWidget);
        expect(find.text('Your 24/7 Virtual Healthcare Assistant'), findsOneWidget);
      });
}