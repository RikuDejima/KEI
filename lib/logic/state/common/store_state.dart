import 'package:flutter/material.dart';
import 'package:key/entity/store.dart';
import 'package:key/logic/repository/store_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:riverpod/riverpod.dart';

final storeDataState = StateProvider<Store?>((ref) => null);
final storeImageUrlsState = StateProvider<List<String>>((ref) => []);
