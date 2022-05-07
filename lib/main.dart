import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:key/logic/controller/route_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,//縦固定
  ]);
  await Firebase.initializeApp();
  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  @override
  // void initState() {
  //   super.initState();
    
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: RoutemasterParser(),
      routerDelegate: routemaster,
    );
  }
}