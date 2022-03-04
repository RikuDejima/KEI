import 'package:flutter/material.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/view_controller/root_view_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RootScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewController = ref.watch(rootViewController);
    useEffect(() {
      ref.read(rootViewController).attempAutoLogin();
      if (ref.read(firebaseUserState.notifier).state != null) {
        ref.read(routeController).push(AppRoute.home);
      }
      // return;
    }, []);

    return Scaffold(
      backgroundColor: const Color(0xFFE28200),
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              // initialValue: 'メールアドレス',
              onChanged: (value) =>
                  ref.read(mailAddress.notifier).state = value,
              validator: (value) => viewController.validateEmail(value),
            ),
            TextFormField(
              // initialValue: 'パスワード',
              onChanged: (value) => ref.read(password.notifier).state = value,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () async {
                  await viewController.login();
                  if (ref.read(firebaseAuthResultStatus.notifier).state !=
                      FirebaseAuthResultStatus.Successful) {
                    viewController.showErrorDialog(
                      context,
                      ref.read(firebaseAuthResultStatus)!.exceptionMessage(),
                    );
                  }
                },
                child: const Text('Sign in'),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () async {
                  await ref.read(rootViewController).createAccount();
                  if (ref.read(firebaseAuthResultStatus.notifier).state !=
                      FirebaseAuthResultStatus.Successful) {
                    viewController.showErrorDialog(
                      context,
                      ref.read(firebaseAuthResultStatus)!.exceptionMessage(),
                    );
                  }
                },
                child: const Text('Sign up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
