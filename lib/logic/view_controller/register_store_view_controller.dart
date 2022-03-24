import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/state/common/store_state.dart';

final registerStoreViewController =
    Provider((ref) => RegisterStoreViewController(ref.read));
final imagePcker = ImagePicker();

final storeName = StateProvider<String?>((ref) => null);
final location = StateProvider<String?>((ref) => null);
final image = StateProvider<XFile?>((ref) => null);

class RegisterStoreViewController {
  final Reader _read;
  RegisterStoreViewController(this._read);

  Future<void> save() async {
    // print(_read(userName.notifier).state);
    if (_read(storeName.notifier).state == null ||
        _read(location.notifier).state == null) return;
    try {
      await FirebaseFirestore.instance
          .collection(Collection.store.key)
          .doc(_read(firebaseUserState.notifier).state!.uid)
          .set({
        'storeName': _read(storeName.notifier).state,
        'location': _read(location.notifier).state,
      });
    } catch (e) {
      print(e);
      return;
    }

    _read(storeState.notifier).state = _read(storeState)?.copyWith(
        storeName: _read(storeName.notifier).state!,
        location: _read(location.notifier).state!);
  }
}
