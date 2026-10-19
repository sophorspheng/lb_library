import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/core/theme/app_theme.dart';
import 'package:lb_library/core/theme/theme_controller.dart';
import 'package:lb_library/languages/generated/l10n.dart';
import 'package:lb_library/main.dart';
import 'package:lb_library/widgets/language_controller.dart';

class AppLB extends StatefulWidget {
  const AppLB({super.key});
  static final router = AppRoute.configureRouter();

  static BuildContext get context {
    return router.routerDelegate.navigatorKey.currentContext!;
  }

  @override
  State<AppLB> createState() => _AppLBState();
}

class _AppLBState extends State<AppLB> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appThemeController,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: appLanguageController,
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,

              // Theme
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: appThemeController.themeMode,

              // Localization
              locale: appLanguageController.locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
            );
          },
        );
      },
    );
  }
}
