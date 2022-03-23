import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/view_controller/root_view_controller.dart';
import 'package:key/main.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterStoreScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final viewController = ref.watch(rootViewController);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    useEffect(() {
      ref.read(loginLifeCycleState.notifier).state = LoginLifeCycle.register;
    }, []);

    return Scaffold(
      backgroundColor: const Color(0xFF3B2508),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    // initialValue: 'メールアドレス',
                    onChanged: (value) =>
                        ref.read(mailAddress.notifier).state = value,
                    // controller: TextEditingController(
                    //     text: ref.read(mailAddress.notifier).state),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        ref.read(rootViewController).validateEmail(value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'メールアドレスを入力してください',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFA7A7A7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    onChanged: (value) =>
                        ref.read(password.notifier).state = value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (pasword) =>
                        ref.read(rootViewController).validatePassword(pasword),
                    // controller: TextEditingController(
                    //     text: ref.read(password.notifier).state),
                    decoration: InputDecoration(
                      hintText: 'パスワードを入力してください',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFA7A7A7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  // padding: const EdgeInsets.all(10),
                  // color: const Color(0xFFD6A15C),
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFFD6A15C)),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await ref.read(rootViewController).createAccount();
                      if (ref.read(firebaseResultStatus.notifier).state !=
                          FirebaseResultStatus.Successful) {
                        ref.read(rootViewController).showErrorDialog(
                              context,
                              ref
                                  .read(firebaseResultStatus)!
                                  .exceptionMessage(ref),
                            );
                      }
                    },
                    child: const Text(
                      'アカウント作成',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
