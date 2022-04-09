import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/state/common/store_state.dart';
import 'package:key/view/screen/home_screen.dart';
import 'package:key/view/screen/store_profile_screen.dart';

final registerStoreViewController =
    Provider((ref) => RegisterStoreViewController(ref.read));
final imagePcker = ImagePicker();

final storeNameState = StateProvider<String?>((ref) => null);
final locationState = StateProvider<String?>((ref) => null);

class RegisterStoreViewController {
  final Reader _read;
  RegisterStoreViewController(this._read);

  Future<void> save() async {
    // print(_read(userName.notifier).state);
    if (_read(storeNameState.notifier).state == null ||
        _read(locationState.notifier).state == null) return;
    // try {
    await FirebaseFirestore.instance
        .collection(Collection.store.key)
        .doc(_read(firebaseUserState.notifier).state!.uid)
        .set({
      'storeName': _read(storeNameState.notifier).state,
      'location': _read(locationState.notifier).state,
    }).catchError((e) => print(e));

    _read(storeDataState.notifier).state = _read(storeDataState)?.copyWith(
        storeName: _read(storeNameState.notifier).state!,
        location: _read(locationState.notifier).state!);

    _read(pages).add(StoreProfileScreen());
    _read(bottomNavigationBarItems).add(const BottomNavigationBarItem(
      icon: Icon(Icons.storefront),
      label: '店舗プロフィール',
    ));
  }
}
