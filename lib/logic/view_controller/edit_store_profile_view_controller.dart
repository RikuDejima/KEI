// import 'dart:ffi';

// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:key/entity/store.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:key/logic/repository/store_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/state/common/store_state.dart';

final editStoreProfileViewController =
    Provider((ref) => EditStoreProfileViewController(ref.read));

class EditStoreImage {
  final File? file;
  final String? url;
  EditStoreImage({this.file, this.url});

  Image? getImage() {
    if (file != null) {
      return Image.file(
        file!,
        fit: BoxFit.cover,
      );
    } else if (url != null) {
      return Image.network(url!, fit: BoxFit.cover);
    }
  }
}

// final storeProfileItemsState =
//     StateProvider<Store>((ref) => ref.read(storeDataState)!);
final editStoreProfileItemsState =
    StateProvider<Map<String, dynamic>>((ref) => {
          'storeName': ref.watch(storeDataState)?.storeName,
          'Images': ref.watch(storeDataState)?.Images,
          'introduce': ref.watch(storeDataState)?.introduce,
        });

final editStoreImages = StateProvider<List<EditStoreImage>>((ref) => []);
//   List images = [];
//   final storeRef = FirebaseStorage.instance
//       .ref()
//       .child('store/${ref.read(firebaseUserState)!.uid}');
//   storeRef.child('topImage').getDownloadURL().then((value) {
//     images[0] = value;
//   });
//   return images;
// });

class EditStoreProfileViewController {
  final Reader _read;
  EditStoreProfileViewController(this._read);
  void takePicture() async {
    final picker = ImagePicker();
    final Future<XFile?> Image = picker.pickImage(source: ImageSource.camera);
  }

  void chooseImage({required isTop}) async {
    final picker = ImagePicker();
    final cropper = ImageCropper();
    final storeImasgeRef = FirebaseStorage.instance
        .ref()
        .child('store/${_read(firebaseUserState)!.uid}');
    picker.pickImage(source: ImageSource.gallery).then((image) {
      //     'store/${_read(firebaseUserState)!.uid}/topImage';
      // _read(storeImages.notifier).state = [];
      if (image != null) {
        // final images = _read(storeProfileItemsState.notifier).state['Images'] as List;
        cropper
            .cropImage(
                sourcePath: image.path,
                aspectRatio: CropAspectRatio(ratioX: 375, ratioY: 197))
            .then((file) {
          _read(editStoreProfileItemsState.notifier).state['Images'] = [
            image.name
          ];
          _read(editStoreImages.notifier).state = [EditStoreImage(file: file)];
          print(_read(editStoreProfileItemsState.notifier).state);
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  Map<String, dynamic> _initStoreProfileItems = {};
  Future<void> initState() async {
    print(_read(editStoreProfileItemsState.notifier).state);
    _initStoreProfileItems = _read(editStoreProfileItemsState.notifier).state;
    List _images = _initStoreProfileItems['Images'];
    if (_images.isNotEmpty &&
        _read(storeImageUrlsState.notifier).state.isNotEmpty) {
      _read(editStoreImages.notifier).update((state) =>
          [EditStoreImage(url: _read(storeImageUrlsState.notifier).state[0])]);
    }
  }

  Future<bool> save() async {
    final Map<String, dynamic> updatedData = {};

    print('${_read(editStoreProfileItemsState.notifier).state}:editState');
    print('$_initStoreProfileItems:initState');
    _read(editStoreProfileItemsState.notifier).state.forEach((key, value) {
      if (value != _initStoreProfileItems[key]) updatedData[key] = value;
    });
    print('$updatedData:updatedData');
    if (updatedData.isEmpty) return true;
    try {
      await FirebaseFirestore.instance
          .collection(Collection.store.key)
          .doc(_read(firebaseUserState.notifier).state!.uid)
          .update(updatedData);

      _read(storeDataState.notifier).state =
          _read(storeDataState.notifier).state!.copyWith(
                storeName: updatedData['storeName'],
                Images: updatedData['Images'],
                introduce: updatedData['introduce'],
              );
      print(updatedData);
      if (updatedData.containsKey('Images')) {
        final imagesRef = _read(storeRepository)
            .storageRef()
            .child('${_read(firebaseUserState.notifier).state!.uid}');
        final images = updatedData['Images'] as List<String>;
        print(images);
        await Future.forEach(images, (String image) async {
          await imagesRef
              .child(image)
              .putFile(_read(editStoreImages.notifier).state[0].file!);
        });
        print('uploaded file');
        print(_read(editStoreImages.notifier).state[0]);
        return true;
      } else {
        return true;
      }
    } catch (e) {
      print(updatedData);
      print('$e:error');
      return true;
    }
    // return true;
  }
}
