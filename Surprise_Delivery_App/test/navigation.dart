import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpirse_delivery_app/pages/base_map.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';
import 'package:surpirse_delivery_app/pages/settings_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class FakeRoute extends Fake implements Route {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  group("Navigate to View Map", () {
    testWidgets("Navigation", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(),
          navigatorObservers: [mockObserver],
        ),
      );

      Finder viewMapButton = find.byKey(Key("View Map"));
      Finder mapState = find.byType(BaseMap);
      expect(viewMapButton, findsOneWidget);
      tester.ensureVisible(viewMapButton);
      await tester.tap(viewMapButton);
      await tester.pumpAndSettle();

      verify(() => mockObserver.didPush(any(), any()));
      expect(mapState, findsOneWidget);

    });
  });

  group("Navigate to Settings Page", () {
    testWidgets("Navigate", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(),
          navigatorObservers: [mockObserver],
        ),
      );

      Finder settingsButton = find.byKey(Key("Settings Button"));
      Finder settingsState = find.byType(SettingsPage);
      expect(settingsButton, findsOneWidget);

      tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      verify(() => mockObserver.didPush(any(), any()));
      expect(settingsState, findsOneWidget);
    });
  });
  //navigate to pages in settings page
}