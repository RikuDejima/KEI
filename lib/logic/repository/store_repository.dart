import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/entity/store.dart';
import 'package:key/logic/repository/base_repository.dart';

final userRepository = Provider((ref) => StoreRepository(ref.read));

class StoreRepository extends BaseRepository {
  StoreRepository(Reader read) : super(read);
  final _col =
      FirebaseFirestore.instance.collection(Collection.store.key).withConverter(
            fromFirestore: (snapshot, _) => Store.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson(),
          );

  Future<CommonResponse<Store>> getUser(String uid) async {
    
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
}
