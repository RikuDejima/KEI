// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      role: json['role'] as String,
      storeName: json['storeName'] as String?,
      introduce: json['introduce'] as String?,
      image1: json['image1'] as String?,
      image2: json['image2'] as String?,
      image3: json['image3'] as String?,
      location: json['location'] as String?,
      twitterAccount: json['twitterAccount'] as String?,
      instaAcount: json['instaAcount'] as String?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'role': instance.role,
      'storeName': instance.storeName,
      'introduce': instance.introduce,
      'image1': instance.image1,
      'image2': instance.image2,
      'image3': instance.image3,
      'location': instance.location,
      'twitterAccount': instance.twitterAccount,
      'instaAcount': instance.instaAcount,
      'uid': instance.uid,
    };
