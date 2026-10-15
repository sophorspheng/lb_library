import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/home/home_page.dart';
part 'route_handler.dart';

class AppRoute {
  static const String home = "home_page";

  static final List<GoRoute> configs = [
    GoRoute(name: home, path: '/', pageBuilder: _homePageBuilder),
  ];
}
