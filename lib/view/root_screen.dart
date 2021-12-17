import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RootScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // useEffect();

    return const Scaffold(
      backgroundColor: Color(0xFFE28200),
      body: Center(
        child: Text('KEI', style: TextStyle(color: Colors.white, fontSize: 100),),
      ),
    );
  }
}
