import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lb_library/module/home/home_page.dart';
import 'package:lb_library/languages/generated/l10n.dart';
import 'package:lb_library/module/setting/setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lb_library/widgets/language_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('language picker updates the settings page locale', (
    WidgetTester tester,
  ) async {
    await appLanguageController.setLocale(const Locale('en'));

    await tester.pumpWidget(
      ListenableBuilder(
        listenable: appLanguageController,
        builder: (context, child) {
          return MaterialApp(
            locale: appLanguageController.locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: const SettingsPage(),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);

    await tester.ensureVisible(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    expect(find.text('Choose Language'), findsOneWidget);

    await tester.tap(find.text('ខ្មែរ (Khmer)'));
    await tester.pumpAndSettle();

    expect(find.text('ការកំណត់'), findsOneWidget);
    expect(find.text('ភាសា'), findsOneWidget);
    expect(find.text('ខ្មែរ'), findsOneWidget);
  });

  testWidgets('home page labels update when locale changes', (
    WidgetTester tester,
  ) async {
    await appLanguageController.setLocale(const Locale('en'));

    await tester.pumpWidget(
      ListenableBuilder(
        listenable: appLanguageController,
        builder: (context, child) {
          return MaterialApp(
            locale: appLanguageController.locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: const HomePage(),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Explore Categories'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    await appLanguageController.setLocale(const Locale('km'));
    await tester.pumpAndSettle();

    expect(find.text('ស្វែងរកតាមប្រភេទ'), findsOneWidget);
    expect(find.text('ទំព័រដើម'), findsOneWidget);
    expect(find.text('ប្រលោមលោក'), findsOneWidget);
  });
}
