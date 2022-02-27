import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:key/entity/user.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:key/logic/repository/user_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/state/common/login_user_state.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final rootViewController = Provider((ref) => RootViewController(ref.read));

enum FirebaseAuthStatus {
  Successful,
  EmailAlreadyExists,
  WrongPassword,
  InvalidEmail,
  UserNotFound,
  UserDisabled,
  OperationNotAllowed,
  TooManyRequests,
  Undefined,
}

enum LoginLifeCycle {
  initializing,
  login,
}

extension FirebaseAuthStatusExt on FirebaseAuthStatus {
  FirebaseAuthStatus handleException(FirebaseAuthStatus e) {
    switch (e.toString()) {
      case 'invalid-email':
        return FirebaseAuthStatus.InvalidEmail;
      case 'wrong-password':
        return FirebaseAuthStatus.WrongPassword;
      case 'user-disabled':
        return FirebaseAuthStatus.UserDisabled;
      case 'user-not-found':
        return FirebaseAuthStatus.UserNotFound;
      case 'operation-not-allowed':
        return FirebaseAuthStatus.OperationNotAllowed;
      case 'too-many-requests':
        return FirebaseAuthStatus.TooManyRequests;
      case 'email-already-exists':
        return FirebaseAuthStatus.EmailAlreadyExists;
      default:
        return FirebaseAuthStatus.Undefined;
    }
  }
}

String exceptionMessage(FirebaseAuthStatus result) {
  String? message = '';
  switch (result) {
    case FirebaseAuthStatus.Successful:
      message = 'ログインに成功しました。';
      break;
    case FirebaseAuthStatus.EmailAlreadyExists:
      message = '指定されたメールアドレスは既に使用されています。';
      break;
    case FirebaseAuthStatus.WrongPassword:
      message = 'パスワードが違います。';
      break;
    case FirebaseAuthStatus.InvalidEmail:
      message = 'メールアドレスが不正です。';
      break;
    case FirebaseAuthStatus.UserNotFound:
      message = '指定されたユーザーは存在しません。';
      break;
    case FirebaseAuthStatus.UserDisabled:
      message = '指定されたユーザーは無効です。';
      break;
    case FirebaseAuthStatus.OperationNotAllowed:
      message = '指定されたユーザーはこの操作を許可していません。';
      break;
    case FirebaseAuthStatus.TooManyRequests:
      message = '指定されたユーザーはこの操作を許可していません。';
      break;
    case FirebaseAuthStatus.Undefined:
      message = '不明なエラーが発生しました。';
      break;
  }
  return message;
}

final _firebaseAuthStatus = StateProvider<FirebaseAuthStatus?>((ref) => null);
final loginLifeCycleState =
    StateProvider<LoginLifeCycle>((ref) => LoginLifeCycle.initializing);
final mailAddress = StateProvider<String>((ref) => '');
final password = StateProvider<String>((ref) => '');

class RootViewController {
  final Reader _read;
  RootViewController(this._read);

  Future<void> attempAutoLogin() async {
    final res = CommonResponse<User>();
    final auth.User? firebaseUser =
        await auth.FirebaseAuth.instance.authStateChanges().first;
    final CommonResponse<User>? userResponce;

    if (firebaseUser != null) {
      _read(loginLifeCycleState.notifier).state = LoginLifeCycle.login;
      userResponce = await _read(userRepository).getUser(firebaseUser.uid);
    } else {
      userResponce = null;
      return;
    }

    if (userResponce.hasData) {
      _read(loginUserState.notifier).state = userResponce.data;
      _read(firebaseUserState.notifier).state = firebaseUser;
      _read(routeController).push(AppRoute.home);
    } else {
      print(userResponce.errorReason);
    }
  }

  void _emailVerify() {}
  void _passwordVerify() {}

  void login() async {
    try {
      auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _read(mailAddress.notifier).state,
        password: _read(password.notifier).state,
      );
      print('succeed');
      if (userCredential.user != null) {
        _read(_firebaseAuthStatus.notifier).state = FirebaseAuthStatus.Successful;
      } else {
        _read(_firebaseAuthStatus.notifier).state = FirebaseAuthStatus.Undefined;
      }
    } on auth.FirebaseAuthException catch (e) {
      print(e.code);
      _read(_firebaseAuthStatus.notifier).state = _read(_firebaseAuthStatus);
    }

    attempAutoLogin();
  }

  void createAccount() async {
    auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _read(mailAddress.notifier).state,
      password: _read(password.notifier).state,
    );
  }
}
