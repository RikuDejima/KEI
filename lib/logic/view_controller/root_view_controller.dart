// enum AppLifeCycle{
//   initializing,
//   login,
// }
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final rootViewController = Provider((ref) => RootViewController(ref.read));

enum LoginLifeCycle {
  initializing,
  login,
}

class RootViewController {
  final Reader _read;
  RootViewController(this._read);

  void initialize(){

  }

}


