// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Store _$StoreFromJson(Map<String, dynamic> json) {
  return _Store.fromJson(json);
}

/// @nodoc
class _$StoreTearOff {
  const _$StoreTearOff();

  _Store call(
      {required String storeName,
      required String location,
      String? topImage,
      String? introduce,
      List<String>? subImages,
      String? twitterAccount,
      String? instaAcount}) {
    return _Store(
      storeName: storeName,
      location: location,
      topImage: topImage,
      introduce: introduce,
      subImages: subImages,
      twitterAccount: twitterAccount,
      instaAcount: instaAcount,
    );
  }

  Store fromJson(Map<String, Object?> json) {
    return Store.fromJson(json);
  }
}

/// @nodoc
const $Store = _$StoreTearOff();

/// @nodoc
mixin _$Store {
  String get storeName => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get topImage => throw _privateConstructorUsedError;
  String? get introduce => throw _privateConstructorUsedError;
  List<String>? get subImages => throw _privateConstructorUsedError;
  String? get twitterAccount => throw _privateConstructorUsedError;
  String? get instaAcount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StoreCopyWith<Store> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreCopyWith<$Res> {
  factory $StoreCopyWith(Store value, $Res Function(Store) then) =
      _$StoreCopyWithImpl<$Res>;
  $Res call(
      {String storeName,
      String location,
      String? topImage,
      String? introduce,
      List<String>? subImages,
      String? twitterAccount,
      String? instaAcount});
}

/// @nodoc
class _$StoreCopyWithImpl<$Res> implements $StoreCopyWith<$Res> {
  _$StoreCopyWithImpl(this._value, this._then);

  final Store _value;
  // ignore: unused_field
  final $Res Function(Store) _then;

  @override
  $Res call({
    Object? storeName = freezed,
    Object? location = freezed,
    Object? topImage = freezed,
    Object? introduce = freezed,
    Object? subImages = freezed,
    Object? twitterAccount = freezed,
    Object? instaAcount = freezed,
  }) {
    return _then(_value.copyWith(
      storeName: storeName == freezed
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      topImage: topImage == freezed
          ? _value.topImage
          : topImage // ignore: cast_nullable_to_non_nullable
              as String?,
      introduce: introduce == freezed
          ? _value.introduce
          : introduce // ignore: cast_nullable_to_non_nullable
              as String?,
      subImages: subImages == freezed
          ? _value.subImages
          : subImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      twitterAccount: twitterAccount == freezed
          ? _value.twitterAccount
          : twitterAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      instaAcount: instaAcount == freezed
          ? _value.instaAcount
          : instaAcount // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$StoreCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$StoreCopyWith(_Store value, $Res Function(_Store) then) =
      __$StoreCopyWithImpl<$Res>;
  @override
  $Res call(
      {String storeName,
      String location,
      String? topImage,
      String? introduce,
      List<String>? subImages,
      String? twitterAccount,
      String? instaAcount});
}

/// @nodoc
class __$StoreCopyWithImpl<$Res> extends _$StoreCopyWithImpl<$Res>
    implements _$StoreCopyWith<$Res> {
  __$StoreCopyWithImpl(_Store _value, $Res Function(_Store) _then)
      : super(_value, (v) => _then(v as _Store));

  @override
  _Store get _value => super._value as _Store;

  @override
  $Res call({
    Object? storeName = freezed,
    Object? location = freezed,
    Object? topImage = freezed,
    Object? introduce = freezed,
    Object? subImages = freezed,
    Object? twitterAccount = freezed,
    Object? instaAcount = freezed,
  }) {
    return _then(_Store(
      storeName: storeName == freezed
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      topImage: topImage == freezed
          ? _value.topImage
          : topImage // ignore: cast_nullable_to_non_nullable
              as String?,
      introduce: introduce == freezed
          ? _value.introduce
          : introduce // ignore: cast_nullable_to_non_nullable
              as String?,
      subImages: subImages == freezed
          ? _value.subImages
          : subImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      twitterAccount: twitterAccount == freezed
          ? _value.twitterAccount
          : twitterAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      instaAcount: instaAcount == freezed
          ? _value.instaAcount
          : instaAcount // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Store extends _Store {
  const _$_Store(
      {required this.storeName,
      required this.location,
      this.topImage,
      this.introduce,
      this.subImages,
      this.twitterAccount,
      this.instaAcount})
      : super._();

  factory _$_Store.fromJson(Map<String, dynamic> json) =>
      _$$_StoreFromJson(json);

  @override
  final String storeName;
  @override
  final String location;
  @override
  final String? topImage;
  @override
  final String? introduce;
  @override
  final List<String>? subImages;
  @override
  final String? twitterAccount;
  @override
  final String? instaAcount;

  @override
  String toString() {
    return 'Store(storeName: $storeName, location: $location, topImage: $topImage, introduce: $introduce, subImages: $subImages, twitterAccount: $twitterAccount, instaAcount: $instaAcount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Store &&
            const DeepCollectionEquality().equals(other.storeName, storeName) &&
            const DeepCollectionEquality().equals(other.location, location) &&
            const DeepCollectionEquality().equals(other.topImage, topImage) &&
            const DeepCollectionEquality().equals(other.introduce, introduce) &&
            const DeepCollectionEquality().equals(other.subImages, subImages) &&
            const DeepCollectionEquality()
                .equals(other.twitterAccount, twitterAccount) &&
            const DeepCollectionEquality()
                .equals(other.instaAcount, instaAcount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(storeName),
      const DeepCollectionEquality().hash(location),
      const DeepCollectionEquality().hash(topImage),
      const DeepCollectionEquality().hash(introduce),
      const DeepCollectionEquality().hash(subImages),
      const DeepCollectionEquality().hash(twitterAccount),
      const DeepCollectionEquality().hash(instaAcount));

  @JsonKey(ignore: true)
  @override
  _$StoreCopyWith<_Store> get copyWith =>
      __$StoreCopyWithImpl<_Store>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StoreToJson(this);
  }
}

abstract class _Store extends Store {
  const factory _Store(
      {required String storeName,
      required String location,
      String? topImage,
      String? introduce,
      List<String>? subImages,
      String? twitterAccount,
      String? instaAcount}) = _$_Store;
  const _Store._() : super._();

  factory _Store.fromJson(Map<String, dynamic> json) = _$_Store.fromJson;

  @override
  String get storeName;
  @override
  String get location;
  @override
  String? get topImage;
  @override
  String? get introduce;
  @override
  List<String>? get subImages;
  @override
  String? get twitterAccount;
  @override
  String? get instaAcount;
  @override
  @JsonKey(ignore: true)
  _$StoreCopyWith<_Store> get copyWith => throw _privateConstructorUsedError;
}
