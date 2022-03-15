import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDD1),
      body: const Center(
        child: Text(
          'KEI',
          style: TextStyle(color: Colors.white, fontSize: 100),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.notifications)),
      //     BottomNavigationBarItem(icon: Icon(Icons.home)),
      //   ],
      // ),
    );
  }
}
