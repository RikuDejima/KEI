import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/state/common/login_user_state.dart';
import 'package:key/logic/view_controller/user_profile_view_controller.dart';
import 'package:key/logic/view_controller/root_view_controller.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditProfileScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewController = ref.read(editProfileViewController);
    useEffect(
      () {
        ref.read(initialValueState.notifier).state =
            ref.read(loginUserState.notifier).state?.name;
        ref.read(isSavedState.notifier).state = false;
      },
      [],
    );
    return Scaffold(
      appBar: AppBar(
          // actions: [],
          ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('名前'),
            TextField(
              onChanged: (str) => ref.read(userNameState.notifier).state = str,
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await viewController.save();
                  Navigator.pop(context);
                },
                child: Text(
                  '保存',
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, fontWeight: 600),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 7),
                  ),
                  fixedSize: MaterialStateProperty.all(double.infinity),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF3B2508)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
