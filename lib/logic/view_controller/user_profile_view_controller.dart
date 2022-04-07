import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:key/entity/user.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/state/common/login_user_state.dart';
import 'package:key/logic/view_controller/root_view_controller.dart';

final editProfileViewController =
    Provider((ref) => UserProfileViewController(ref.read));

final userNameState = StateProvider<String?>(
  (ref) => ref.read(loginUserState.notifier).state?.name,
);
final initialValueState = StateProvider<String?>((ref) => null);
final isSavedState = StateProvider<bool>((ref) => false);

class UserProfileViewController {
  final Reader _read;
  UserProfileViewController(this._read);

  Future<void> save() async {
    //TO DO: make sure editedName wether edtited or not
    print(_read(userNameState.notifier).state);
    if (_read(initialValueState.notifier).state == _read(userNameState.notifier).state) {
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection(Collection.user.key)
          .doc(_read(firebaseUserState.notifier).state!.uid)
          .update({'name': _read(userNameState.notifier).state});
    } catch (e) {
      print(e);
      return;
    }

    _read(loginUserState.notifier).state = _read(loginUserState)!
        .copyWith(name: _read(userNameState.notifier).state);
  }
}
