import 'package:flutter/material.dart';
import 'package:key/main.dart';
import 'package:key/view/register_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:riverpod/riverpod.dart';
import 'package:key/view/root_screen.dart';
import 'package:key/view/home_screen.dart';

final routeController = Provider((ref) => RouteController(ref.read));

enum AppRoute {
  root,
  register,
  home,
}

extension AppRouteExt on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.root:
        return '/';
      default:
        return '/${toString().split('.').last}';
    }
  }

  // static AppRoute fromPath(String path) =>
  //     AppRoute.values.firstWhere((AppRoute route) => route.path == path);
}

final route = RouteMap(routes: {
  AppRoute.root.path: (data) => MaterialPage(child: RootScreen()),
  AppRoute.register.path: (data) => MaterialPage(child: RegisterScreen()),
  AppRoute.home.path: (data) => MaterialPage(child: HomeScreen()),
});

final routemaster = RoutemasterDelegate(routesBuilder: (context) => route);

class RouteController {
  Reader _read;
  RouteController(this._read);

  Future<NavigationResult> push(AppRoute route) async {
    return routemaster.push(route.path);
  }

  Future<bool> pop({dynamic result}) async {
    return routemaster.pop(result);
  }

  void replace(AppRoute route) {
    routemaster.replace(route.path);
  }
}
