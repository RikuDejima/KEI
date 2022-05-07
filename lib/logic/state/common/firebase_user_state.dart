import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

final firebaseUserState = StateProvider<auth.User?>((ref) => null);