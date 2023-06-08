import 'package:enwords/src/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/dashboard/bloc/dashboard_bloc.dart';
import '../presentation/home/home_screen.dart';
import 'app_get.dart';

GlobalKey<NavigatorState> get navigatorKey =>
    findInstance<GlobalKey<NavigatorState>>();

// GoRouter configuration
final goRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: "/", 
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      name: 'dashboard',
      path: '/dashboard/:menu',
      builder: (context, state) {
        DashboardMenu? menu;
        if (DashboardMenu.values
            .any((e) => e.name == state.pathParameters['menu'])) {
          menu = DashboardMenu.values.byName(state.pathParameters['menu']!);
        }
        findInstance<DashboardBloc>().add(InitDashboardEvent(menu: menu));
        return const DashboardScreen();
      },
    ),
  ],
);
