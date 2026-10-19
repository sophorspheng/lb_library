import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/core/network/network_api.dart';
import 'package:lb_library/core/storage/preferences_service.dart';
import 'package:lb_library/module/login/login_page.dart';
import 'package:lb_library/module/login/model/user_model.dart';
import 'package:lb_library/module/login/service/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    NetworkAPI.instance.dio.options.headers.remove('Authorization');
  });

  testWidgets('remember me persists username and applies login token', (
    WidgetTester tester,
  ) async {
    final router = _createRouter(loginService: _SuccessfulLoginService());
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'admin');
    await tester.enterText(find.byType(TextFormField).last, '12341234');
    await tester.tap(find.byType(Checkbox));
    await tester.ensureVisible(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('remembered_login_email'), 'admin');
    expect(preferences.getString('remembered_login_password'), isNull);
    expect(preferences.getBool('auth_logged_out'), isFalse);
    expect(
      NetworkAPI.instance.dio.options.headers['Authorization'],
      'Bearer test-token',
    );
  });

  test('persists logged-out state for the next app launch', () async {
    final preferences = PreferencesService.instance;

    expect(await preferences.loadLoggedOut(), isTrue);
    expect(
      AppRoute.initialLocation(loggedOut: await preferences.loadLoggedOut()),
      '/login',
    );

    await preferences.saveLoggedOut(true);
    expect(await preferences.loadLoggedOut(), isTrue);
    expect(
      AppRoute.initialLocation(loggedOut: await preferences.loadLoggedOut()),
      '/login',
    );

    await preferences.saveLoggedOut(false);
    expect(await preferences.loadLoggedOut(), isFalse);
    expect(
      AppRoute.initialLocation(loggedOut: await preferences.loadLoggedOut()),
      '/',
    );
  });

  testWidgets('shows a message when the login server is unavailable', (
    WidgetTester tester,
  ) async {
    final router = _createRouter(loginService: _UnavailableLoginService());
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'admin@num.com.kh',
    );
    await tester.enterText(find.byType(TextFormField).last, '12341234');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Unable to connect to the server'), findsOneWidget);
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

GoRouter _createRouter({LoginService? loginService}) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        name: AppRoute.login,
        path: '/login',
        builder: (context, state) => LoginPage(loginService: loginService),
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

class _SuccessfulLoginService extends LoginService {
  @override
  Future<UserModel> authUser({
    required String username,
    required String password,
  }) async {
    return UserModel(token: 'test-token', type: 'Bearer');
  }
}

class _UnavailableLoginService extends LoginService {
  @override
  Future<UserModel> authUser({
    required String username,
    required String password,
  }) async {
    throw const NetworkException(message: 'Unable to connect to the server');
  }
}
