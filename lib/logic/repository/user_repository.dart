import 'package:key/entity/user.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userRepository = Provider((ref) => UserRepository(ref.read));

class UserRepository extends BaseRepository {
  UserRepository(Reader read) : super(read);
  final _col =
      FirebaseFirestore.instance.collection(Collection.user.key).withConverter(
            fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson(),
          );

  Future<CommonResponse<User>> getUser(String uid) async {
    final ret = CommonResponse<User>();
    final DocumentSnapshot? snapshot = await _col.doc(uid).get().catchError(
      (error) {
        if (error.code != 'permission-denied') {
          ret.errorReason = error.toString();
        }
      },
    );
    final data = snapshot?.data();
    if (snapshot == null || !snapshot.exists || data == null) {
      return ret;
    }
    ret.data = data;
    return ret;
  }
}
