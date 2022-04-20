import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:riverpod/riverpod.dart';
import 'package:key/entity/store.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:key/logic/state/common/store_state.dart';

final storeRepository = Provider((ref) => StoreRepository(ref.read));

class StoreRepository extends BaseRepository {
  StoreRepository(this._read) : super(_read);
  final Reader _read;
  final _col =
      FirebaseFirestore.instance.collection(Collection.store.key).withConverter(
            fromFirestore: (snapshot, _) => Store.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson(),
          );

  Reference storageRef() {
    return FirebaseStorage.instance.ref().child('${Collection.store.key}/$uid');
  }

  Future<CommonResponse<Store>> getStore(String uid) async {
    final ret = CommonResponse<Store>();
    final DocumentSnapshot? snapshot = await _col.doc(uid).get().catchError(
      (error) {
        if (error.code != 'permission-denied') {
          ret.errorReason = error.toString();
        }
        throw error;
      },
    );
    final data = snapshot?.data();
    if (snapshot == null || !snapshot.exists || data == null) {
      print("couldn't get user");
      return ret;
    }
    ret.data = data;
    return ret;
  }

  // List<Image>
  // Future<String> getImagesUrl(String name) {
  //   return storageRef.child('$uid/$name').getDownloadURL();
  // }
}
