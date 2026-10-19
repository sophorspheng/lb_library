import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/core/storage/preferences_service.dart';
import 'package:lb_library/core/theme/theme_controller.dart';
import 'package:lb_library/module/app/view/app_lb.dart';
import 'package:lb_library/widgets/language_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = PreferencesService.instance;
  final results = await Future.wait([
    appLanguageController.loadSavedLocale(),
    appThemeController.loadSavedThemeMode(),
    preferences.loadLoggedOut(),
  ]);
  appRouter = GoRouter(
    initialLocation: AppRoute.initialLocation(loggedOut: results[2] as bool),
    routes: AppRoute.configs,
  );
  runApp(const ReadoraApp());
}

late final GoRouter appRouter;
