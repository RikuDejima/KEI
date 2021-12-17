import 'package:key/logic/repository/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String role,
    required String storeName,
    String? introduce,
    String? image1,
    String? image2,
    String? image3,
    String? location,
    String? twitterAccount,
    String? instaAcount,
    String? uid,
  }) = _User;
  
  DocumentReference get ref => FirebaseFirestore.instance.collection(Collection.user.key).doc(uid);
}
