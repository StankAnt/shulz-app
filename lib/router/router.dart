import 'package:flutter/material.dart';

import 'package:shulz/router/screens_routes.dart';

import 'package:shulz/login/login.dart';
import 'package:shulz/shulz/shulz.dart';

import 'package:shulz/repositories/user_repository.dart';

class Router {
  UserRepository _userRepository;
  Map<String, WidgetBuilder> routes;
  bool _isAuthenticated;

  Router({
    @required UserRepository userRepository,
    @required bool isAuthenticated,
  }) {
    _userRepository = userRepository;
    _isAuthenticated = isAuthenticated;

    final Map<String, WidgetBuilder> anonymousRoutes = {
      ScreensRoutes.main: (context) => LoginPage(
            userRepository: _userRepository,
          ),
    };

    final Map<String, WidgetBuilder> authenticatedRoutes = {
      ScreensRoutes.main: (context) => ShulzPage(),
      ScreensRoutes.some: (context) => ShulzPage(),
    };

    routes = isAuthenticated ? authenticatedRoutes : anonymousRoutes;
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    final name = settings.name;

    return new MaterialPageRoute(
      builder: routes[name],
      settings: settings,
    );
  }

  Navigator buildNavigator() {
    return Navigator(
      key: new ValueKey(_isAuthenticated),
      onGenerateRoute: _generateRoute,
      onUnknownRoute: (RouteSettings settings) {
        throw Exception('unknown route');
      },
    );
  }
}
