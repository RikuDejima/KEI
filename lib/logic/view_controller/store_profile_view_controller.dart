import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:key/entity/store.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/state/common/store_state.dart';

final storeProfileViewController =
    Provider((ref) => StoreProfileViewController(ref.read));

// final storeProfileItemsState =
//     StateProvider<Store>((ref) => ref.read(storeDataState)!);
final storeProfileItemsState = StateProvider<Map<String, dynamic>>((ref) => {
      'storeName': ref.watch(storeDataState)?.storeName,
      'topImage': ref.watch(storeDataState)?.topImage,
      'introduce': ref.watch(storeDataState)?.introduce,
    });

class StoreProfileViewController {
  final Reader _read;
  StoreProfileViewController(this._read);

  void takePicture(){
    final picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery);
  }

  void chooseImage(){}

  Map<String, dynamic> _initStoreProfileItems = {};
  void initState() {
    _initStoreProfileItems = _read(storeProfileItemsState.notifier).state;
  }

  Future<void> save() async {
    final Map<String, dynamic> updatedData = {};

    _read(storeProfileItemsState).forEach((key, value) {
      if (value != _initStoreProfileItems[key]) updatedData[key] = value;
    });
    if (updatedData.isEmpty) return;
    await FirebaseFirestore.instance
        .collection(Collection.store.key)
        .doc(_read(firebaseUserState.notifier).state!.uid)
        .update(updatedData)
        .catchError((e) {
      print(e);
      return;
    });
    _read(storeDataState.notifier).state =
        _read(storeDataState.notifier).state!.copyWith(
              storeName: updatedData['storeName'],
              topImage: updatedData['topImage'],
              introduce: updatedData['introduce'],
            );
  }
}
