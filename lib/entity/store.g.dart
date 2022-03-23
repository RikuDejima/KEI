// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Store _$$_StoreFromJson(Map<String, dynamic> json) => _$_Store(
      storeName: json['storeName'] as String,
      location: json['location'] as String,
      topImage: json['topImage'] as String,
      introduce: json['introduce'] as String?,
      subImages: (json['subImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      twitterAccount: json['twitterAccount'] as String?,
      instaAcount: json['instaAcount'] as String?,
    );

Map<String, dynamic> _$$_StoreToJson(_$_Store instance) => <String, dynamic>{
      'storeName': instance.storeName,
      'location': instance.location,
      'topImage': instance.topImage,
      'introduce': instance.introduce,
      'subImages': instance.subImages,
      'twitterAccount': instance.twitterAccount,
      'instaAcount': instance.instaAcount,
    };
