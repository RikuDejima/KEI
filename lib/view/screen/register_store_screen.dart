import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/view_controller/register_store_view_controller.dart';
import 'package:key/logic/view_controller/root_view_controller.dart';
import 'package:key/main.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterStoreScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewController = ref.read(registerStoreViewController);
    // final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    // useEffect(() {
    //   ref.read(loginLifeCycleState.notifier).state = LoginLifeCycle.register;
    // }, []);

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
            Text('店舗名'),
            TextField(
              onChanged: (str) => ref.read(storeNameState.notifier).state = str,
            ),
            SizedBox(height: 30),
            Text('所在地'),
            TextField(
              onChanged: (str) => ref.read(locationState.notifier).state = str,
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
