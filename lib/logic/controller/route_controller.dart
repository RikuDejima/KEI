import 'package:flutter/material.dart';
import 'package:key/main.dart';
import 'package:routemaster/routemaster.dart';
import 'package:key/view/root_screen.dart';

enum AppRoute {
  root,
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
  AppRoute.root.path : (data) => MaterialPage(child: RootScreen()),
  AppRoute.home.path : (data) => MaterialPage(child: RootScreen()),
});

final routemaster = RoutemasterDelegate(routesBuilder: (context) => route);

Future<NavigationResult> push(AppRoute route) async {
  return routemaster.push(route.path);
}

Future<bool> pop({dynamic result}) async {
  return routemaster.pop(result);
}

void replace(AppRoute route) {
    routemaster.replace(route.path);
}
