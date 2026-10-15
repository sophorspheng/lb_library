import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';

void main(){
  runApp(
    

    const AppLB());
}

final GoRouter appRouter = GoRouter(
 initialLocation: '/',
 routes: AppRoute.configs,
);
class AppLB extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
       routerConfig: appRouter,);
  }
}