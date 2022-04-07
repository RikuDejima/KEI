import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';

final storeProfileViewController =
    Provider((ref) => StoreProfileViewController(ref.read));

final storeNameState = StateProvider<String?>((ref) => null);
final storeImageState = StateProvider<XFile?>((ref) => null);
final subImagesState = StateProvider<List<XFile>?>((ref) => null);
final introduceState = StateProvider<String?>((ref) => null);

class StoreProfileItem {
  final String? storeName;
  final XFile? storeImage;
  final String? introduce;
  final List<String>? subStoreImages;

  StoreProfileItem({
    this.storeName,
    this.storeImage,
    this.introduce,
    this.subStoreImages,
  });
}

class StoreProfileViewController {
  final Reader _read;
  StoreProfileViewController(this._read);

  Future<void> save() async {
    final Map<String, dynamic> updatedData;

    await FirebaseFirestore.instance
        .collection(Collection.store.key)
        .doc(_read(firebaseUserState.notifier).state!.uid)
        .update({
      'storeName': _read(storeNameState.notifier).state,
      'storeImage': _read(storeImageState.notifier).state,
      'introduce': _read(introduceState.notifier).state,
    });
    
    
  }
}
