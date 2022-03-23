import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Collection {
  user,
  store,
}

extension CollectionExtension on Collection {
  String get key => toString().split('.').last;
}

abstract class BaseRepository {
  BaseRepository(this._read);
  final Reader _read;
  String get uid => _read(firebaseUserState)!.uid;
}

class FirestoreResponse<T> extends CommonResponse<T> {
  DocumentSnapshot? lastDocumentSnapshot;
}

class CommonResponse<T> {
  T? _data;
  T? get data => _data;
  set data(val) {
    _data = val;
  }

  String? errorReason;

  bool get hasError => errorReason != null && errorReason!.isNotEmpty;
  bool get success => !hasError;
  bool get isNull => success && _data == null;
  bool get hasData => success && _data != null;
  bool get hasErrorOrNull => hasError || isNull;
}
