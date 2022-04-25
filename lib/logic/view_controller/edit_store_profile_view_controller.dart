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
final editStoreItemsState = StateProvider<Map<String, dynamic>>((ref) => {
      'Images': ref.watch(storeDataState)?.Images,
      'storeName': ref.watch(storeDataState)?.storeName,
      'introduce': ref.watch(storeDataState)?.introduce,
      'location': ref.watch(storeDataState)?.location,
      'advertisementImage': ref.watch(storeDataState)?.advertisementImage,
    });

final editStoreImages = StateProvider<List<EditStoreImage>>((ref) => []);

class EditStoreProfileViewController {
  final Reader _read;
  EditStoreProfileViewController(this._read);
  Future<void> takePicture({required bool isAdvertisement}) async {
    final picker = ImagePicker();
    final cropper = ImageCropper();
    picker.pickImage(source: ImageSource.gallery).then((xFile) {
      cropper
          .cropImage(
              sourcePath: xFile!.path,
              aspectRatio: CropAspectRatio(ratioX: 375, ratioY: 197))
          .then((file) {
        if (isAdvertisement) {
          _read(editStoreItemsState.notifier).state['advertisementImages'] = [xFile.name];
          _read(editStoreImages.notifier).state = [EditStoreImage(file: file)];
        } else {
          _read(editStoreItemsState.notifier).state['Images'] = [xFile.name];
          _read(editStoreImages.notifier).state = [EditStoreImage(file: file)];
        }
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> chooseImage({required bool isAdvertisement}) async {
    final picker = ImagePicker();
    final cropper = ImageCropper();
    final storeImasgeRef = FirebaseStorage.instance
        .ref()
        .child('store/${_read(firebaseUserState)!.uid}');
    picker.pickImage(source: ImageSource.gallery).then((xFile) {
      cropper
          .cropImage(
              sourcePath: xFile!.path,
              aspectRatio: CropAspectRatio(ratioX: 375, ratioY: 197))
          .then((file) {
        if (isAdvertisement) {
          _read(editStoreItemsState.notifier).state['advertisementImages'] = [xFile.name];
          _read(editStoreImages.notifier).state = [EditStoreImage(file: file)];
        } else {
          _read(editStoreItemsState.notifier).state['Images'] = [xFile.name];
          _read(editStoreImages.notifier).state = [EditStoreImage(file: file)];
        }
      });
    }).catchError((e) {
      print(e);
    });
  }

  Map<String, dynamic> _initStoreProfileItems = {};
  Future<void> initState() async {
    print(_read(editStoreItemsState.notifier).state);
    _initStoreProfileItems = {
      'storeName': _read(storeDataState.notifier).state?.storeName,
      'Images': _read(storeDataState.notifier).state?.Images,
      'introduce': _read(storeDataState.notifier).state?.introduce,
      'location': _read(storeDataState.notifier).state?.location,
    };
    List _images = _initStoreProfileItems['Images'];
    if (_images.isNotEmpty &&
        _read(storeImageUrlsState.notifier).state.isNotEmpty) {
      _read(editStoreImages.notifier).update((state) =>
          [EditStoreImage(url: _read(storeImageUrlsState.notifier).state[0])]);
    }
  }

  String? mapLinkValidation(String? url) {
    if (url != null &&
        Uri.parse(url).isAbsolute &&
        (url.contains('https://www.google.co.jp/maps/') ||
            url.contains('https://g.page/'))) {
      return null;
    } else {
      return 'GoogleMapのリンクを貼ってください';
    }
  }

  Future<bool> save() async {
    final Map<String, dynamic> editedData = {};
    final editStoreProfileItems = _read(editStoreItemsState.notifier).state;

    print('${_read(editStoreItemsState.notifier).state}:editState');
    print('$_initStoreProfileItems:initState');
    _read(editStoreItemsState.notifier).state.forEach((key, value) {
      if (value != _initStoreProfileItems[key]) editedData[key] = value;
    });
    print('$editedData:updatedData');
    if (editedData.isEmpty) return true;
    try {
      await FirebaseFirestore.instance
          .collection(Collection.store.key)
          .doc(_read(firebaseUserState.notifier).state!.uid)
          .update(editedData)
          .catchError((e) {
        print(e);
        return;
      });

      _read(storeDataState.notifier).state =
          _read(storeDataState.notifier).state!.copyWith(
                storeName: editStoreProfileItems['storeName'],
                Images: editStoreProfileItems['Images'],
                introduce: editStoreProfileItems['introduce'],
              );
      print(editedData);
      if (editedData.containsKey('Images')) {
        final imagesRef = _read(storeRepository).storageRef();
        final editedImages = editedData['Images'] as List<String>;
        final imageUrls = [];
        print(editedImages);
        await Future.forEach(editedImages, (String image) async {
          await imagesRef
              .child(image)
              .putFile(_read(editStoreImages.notifier).state[0].file!);
          await imagesRef
              .child(image)
              .getDownloadURL()
              .then((url) => imageUrls.add(url));
        });
        _read(storeImageUrlsState.notifier).state = [...imageUrls];
        // final imageRef = _read(storeRepository).storageRef().child('$element');
        // await imageRef.getDownloadURL().then((value) => images.add(value));
        print('uploaded file');
        print(_read(editStoreImages.notifier).state[0]);
        return true;
      } else {
        return true;
      }
    } catch (e) {
      print('$e:error');
      return true;
    }
  }
}
