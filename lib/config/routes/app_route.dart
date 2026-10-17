
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/home/home_page.dart';
import 'package:lb_library/module/login/login_page.dart';
import 'package:lb_library/module/login/signup_page.dart';

part 'route_handler.dart';

class AppRoute {
  static const String home = 'home_page';
  static const String login = 'login';
  static const String signup = 'signup';

  static final List<GoRoute> configs = [
    GoRoute(
      name: login,
      path: '/login',
      pageBuilder: _loginPageBuilder,
    ),
    GoRoute(
      name: signup,
      path: '/signup',
      pageBuilder: _signupPageBuilder,
    ),
    GoRoute(
      name: home,
      path: '/',
      pageBuilder: _homePageBuilder,
    ),
  ];
}
