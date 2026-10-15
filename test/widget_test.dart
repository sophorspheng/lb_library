import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lb_library/core/theme/theme_controller.dart';

void main() {
  testWidgets('theme toggle switches the app to dark mode', (
    WidgetTester tester,
  ) async {
    appThemeController.setThemeMode(ThemeMode.light);
    // await tester.pumpWidget(const AppLB());

    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.light,
    );

    await tester.tap(find.byIcon(Icons.brightness_2_rounded));
    await tester.pumpAndSettle();

    expect(appThemeController.themeMode, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.dark,
    );
  });
}
