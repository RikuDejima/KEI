import 'package:flutter/material.dart';
import 'package:key/main.dart';
import 'package:key/view/edit_profile_screen.dart';
import 'package:key/view/register_screen.dart';
import 'package:key/view/register_store.dart';
import 'package:routemaster/routemaster.dart';
import 'package:riverpod/riverpod.dart';
import 'package:key/view/root_screen.dart';
import 'package:key/view/home_screen.dart';

final routeController = Provider((ref) => RouteController(ref.read));

enum AppRoute {
  root,
  registerUser,
  home,
  editProfile,
  registerStore,
}

extension AppRouteExt on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.root:
        return '/';
      case AppRoute.registerUser:
       return '/register';
      case AppRoute.editProfile:
        return '/home/editProfile';
      case AppRoute.registerStore:
        return '/home/registerStore';
      default:
        return '/${toString().split('.').last}';
    }
  }

  // static AppRoute fromPath(String path) =>
  //     AppRoute.values.firstWhere((AppRoute route) => route.path == path);
}

final route = RouteMap(routes: {
  AppRoute.root.path: (data) => MaterialPage(child: RootScreen()),
  AppRoute.registerUser.path: (data) => MaterialPage(child: RegisterUserScreen()),
  AppRoute.home.path: (data) => MaterialPage(child: HomeScreen()),
  AppRoute.editProfile.path: (data) => MaterialPage(child: EditProfileScreen()),
  AppRoute.registerStore.path: (data) => MaterialPage(child: RegisterStoreScreen()),
});

final routemaster = RoutemasterDelegate(routesBuilder: (context) => route);

class RouteController {
  Reader _read;
  RouteController(this._read);

  Future<NavigationResult> push(AppRoute route) async {
    return routemaster.push(route.path);
  }

  Future<bool> pop() async {
    return routemaster.popRoute();
  }

  void replace(AppRoute route) {
    routemaster.replace(route.path);
  }
}
