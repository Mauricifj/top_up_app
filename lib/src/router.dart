import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth/domain/auth_service.dart';
import 'auth/presentation/login_page.dart';
import 'dependency_injection.dart';
import 'profile/profile_page.dart';

final GoRouter router = GoRouter(
  initialLocation: LoginPage.path,
  redirect: (context, state) {
    return serviceLocator<AuthService>().user == null
        ? LoginPage.path
        : ProfilePage.path;
  },
  refreshListenable: serviceLocator<AuthService>(),
  routes: <RouteBase>[
    GoRoute(
      path: LoginPage.path,
      builder: (context, state) {
        return LoginPage(
          authService: serviceLocator<AuthService>(),
        );
      },
    ),
    GoRoute(
      path: ProfilePage.path,
      builder: (BuildContext context, GoRouterState state) {
        return ProfilePage(
          authService: serviceLocator<AuthService>(),
        );
      },
    ),
  ],
);
