// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      name: json['name'] as String?,
      storeData: json['storeData'] == null
          ? null
          : Store.fromJson(json['storeData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'name': instance.name,
      'storeData': instance.storeData,
    };
