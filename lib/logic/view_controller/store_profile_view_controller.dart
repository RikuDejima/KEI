import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/logic/repository/store_repository.dart';
import 'package:key/logic/state/common/store_state.dart';

final storeProfileViewController =
    Provider((ref) => StoreProfileViewController(ref.read));

class StoreProfileViewController {
  final Reader _read;
  StoreProfileViewController(this._read);

  Future<void> initState() async {
    final List<String> images = [];
    if (_read(storeDataState.notifier).state?.Images != null) {
      await Future.forEach(_read(storeDataState.notifier).state!.Images!,
          (element) async {
        final imageRef = _read(storeRepository).storageRef().child('$element');
        await imageRef.getDownloadURL().then((value) => images.add(value));
      });
      _read(storeImageUrlsState.notifier).update((state) => [...images]);
    }
  }
}
