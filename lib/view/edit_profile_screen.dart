import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/state/common/login_user_state.dart';
import 'package:key/logic/view_controller/edit_profile_controller.dart';
import 'package:key/logic/view_controller/root_view_controller.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditProfileScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewController = ref.read(editProfileViewController);
    useEffect(
      () {
        ref.read(initialValue.notifier).state =
            ref.read(loginUserState.notifier).state?.name;
        ref.read(isSaved.notifier).state = false;
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
              onChanged: (str) => ref.read(userName.notifier).state = str,
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await viewController.save();
                  // ref.read(routeController).pop();
                  routemaster.pop();
                },
                child: Text(
                  '保存',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 7),
                  ),
                  fixedSize: MaterialStateProperty.all(Size.infinite),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF3B2508)),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
