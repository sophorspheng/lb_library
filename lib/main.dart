import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/lb/app_lb.dart';

void main() {
  runApp(const AppLB());
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: AppRoute.configs,
);
