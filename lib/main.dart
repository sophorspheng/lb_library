import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/core/theme/theme_controller.dart';
import 'package:lb_library/widgets/language_controller.dart';
import 'package:lb_library/lb/app_lb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    appLanguageController.loadSavedLocale(),
    appThemeController.loadSavedThemeMode(),
  ]);
  runApp(const AppLB());
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: AppRoute.configs,
);
