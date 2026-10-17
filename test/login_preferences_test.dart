import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/module/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('remember me persists email but not password', (
    WidgetTester tester,
  ) async {
    final router = _createRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'admin@num.com.kh',
    );
    await tester.enterText(find.byType(TextFormField).last, '12341234');
    await tester.tap(find.byType(Checkbox));
    await tester.ensureVisible(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('remembered_login_email'), 'admin@num.com.kh');
    expect(preferences.getString('remembered_login_password'), isNull);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('restores remembered email and checkbox state', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'remembered_login_email': 'admin@num.com.kh',
    });
    final router = _createRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    final emailField = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(emailField.controller!.text, 'admin@num.com.kh');
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });
}

GoRouter _createRouter() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        name: AppRoute.login,
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: AppRoute.home,
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Home'))),
      ),
    ],
  );
}
