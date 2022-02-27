import 'package:flutter/material.dart';
import 'package:key/logic/view_controller/root_view_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RootScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(rootViewController).attempAutoLogin();
      return;
    }, []);

    return Scaffold(
      backgroundColor: const Color(0xFFE28200),
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              initialValue: 'メールアドレス',
              onChanged: (value) =>
                  ref.read(mailAddress.notifier).state = value,
            ),
            TextFormField(
              initialValue: 'パスワード',
              onChanged: (value) => ref.read(password.notifier).state = value,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () => ref.read(rootViewController).login(),
                child: const Text('Sign in'),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () => ref.read(rootViewController).createAccount(),
                child: const Text('Sign up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
