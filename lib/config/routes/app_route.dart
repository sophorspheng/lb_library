import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/module/home/home_page.dart';
import 'package:lb_library/module/library/book_view_detail.dart';
import 'package:lb_library/module/login/model/get_book_list.dart';
import 'package:lb_library/module/login/login_page.dart';
import 'package:lb_library/module/login/signup_page.dart';

part 'route_handler.dart';

class AppRoute {
  static const String home = 'home_page';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String bookViewDetail = 'book-view-detail';

  static String initialLocation({required bool loggedOut}) =>
      loggedOut ? '/login' : '/';

  static final List<GoRoute> configs = [
    GoRoute(name: login, path: '/login', pageBuilder: _loginPageBuilder),
    GoRoute(name: signup, path: '/signup', pageBuilder: _signupPageBuilder),
    GoRoute(
      name: home,
      path: '/',
      pageBuilder: _homePageBuilder,
      routes: [
        GoRoute(
          path: '/bookviewdetail',
          name: bookViewDetail,
          pageBuilder: _bookViewDetailBuilder,
        ),
      ],
    ),
  ];
  static bool _isPublicLocation(String location) {
    return location.startsWith('/login') ||
        location.startsWith('/signup') ||
        location.startsWith('/home_page');
  }

  static GoRouter configureRouter() {
    return GoRouter(
      routes: AppRoute.configs,
      initialLocation: '/splash',
      redirect: (context, state) {
        // Auth guard: protected routes (home tree, payments, deeplink
        // targets) require a cached session; otherwise route to onboarding.
        final location = state.matchedLocation;

        return _isPublicLocation(location) ? null : '/login';
      },
      debugLogDiagnostics: kDebugMode,
    );
  }
}
