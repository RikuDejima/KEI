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
    Provider((ref) => EditProfileController(ref.read));

final userName = StateProvider<String?>(
  (ref) => ref.read(loginUserState.notifier).state?.name,
);
final initialValue = StateProvider<String?>((ref) => null);
final isSaved = StateProvider<bool>((ref) => false);

class EditProfileController {
  final Reader _read;
  EditProfileController(this._read);

  Future<void> save() async {
    //TO DO: make sure editedName wether edtited or not
    print(_read(userName.notifier).state);
    if (_read(initialValue.notifier).state == _read(userName.notifier).state) {
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection(Collection.user.key)
          .doc(_read(firebaseUserState.notifier).state!.uid)
          .update({'customerName': _read(userName.notifier).state});
    } catch (e) {
      print(e);
      return;
    }

    _read(loginUserState.notifier).state = _read(loginUserState)!
        .copyWith(name: _read(userName.notifier).state);
  }
}
