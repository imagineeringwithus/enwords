import 'package:enwords/src/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import 'app_get.dart';

GlobalKey<NavigatorState> get navigatorKey =>
    findInstance<GlobalKey<NavigatorState>>();

// GoRouter configuration
final goRouter = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      name: 'dashboard',
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
     
  ],
);
