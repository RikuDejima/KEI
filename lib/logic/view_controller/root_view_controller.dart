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

enum FirebaseAuthResultStatus {
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
  register,
  login,
}

extension FirebaseAuthResultStatusExt on FirebaseAuthResultStatus {
  String exceptionMessage(WidgetRef ref) {
    String? message = '';
    switch (this) {
      case FirebaseAuthResultStatus.Successful:
        message = 'ログインに成功しました。';
        break;
      case FirebaseAuthResultStatus.EmailAlreadyExists:
        message = '指定されたメールアドレスは既に使用されています。';
        break;
      case FirebaseAuthResultStatus.WrongPassword:
        message = 'メールアドレスまたはパスワードが間違っています';
        break;
      case FirebaseAuthResultStatus.InvalidEmail:
        message = 'メールアドレスまたはパスワードが間違っています';
        break;
      case FirebaseAuthResultStatus.UserNotFound:
        message = '指定されたユーザーは存在しません。';
        break;
      case FirebaseAuthResultStatus.UserDisabled:
        message = '指定されたユーザーは無効です。';
        break;
      case FirebaseAuthResultStatus.OperationNotAllowed:
        message = '指定されたユーザーはこの操作を許可していません。';
        break;
      case FirebaseAuthResultStatus.TooManyRequests:
        message = '指定されたユーザーはこの操作を許可していません。';
        break;
      case FirebaseAuthResultStatus.Undefined:
        if(ref.read(loginLifeCycleState) == LoginLifeCycle.initializing){
          message = 'ログインできませんでした';
        } else {
          message = 'アカウントを作成できませんでした';
        }
        break;
    }
    return message;
  }
}

final firebaseAuthResultStatus =
    StateProvider<FirebaseAuthResultStatus?>((ref) => null);
final loginLifeCycleState =
    StateProvider<LoginLifeCycle>((ref) => LoginLifeCycle.initializing);
final mailAddress = StateProvider<String>((ref) => '');
final password = StateProvider<String>((ref) => '');
final verifyMessage = StateProvider<String>((ref) => '');

class RootViewController {
  final Reader _read;
  RootViewController(this._read);

  FirebaseAuthResultStatus handleException(FirebaseException e) {
    switch (e.code) {
      case 'invalid-email':
        return FirebaseAuthResultStatus.InvalidEmail;
      case 'wrong-password':
        return FirebaseAuthResultStatus.WrongPassword;
      case 'user-disabled':
        return FirebaseAuthResultStatus.UserDisabled;
      case 'user-not-found':
        return FirebaseAuthResultStatus.UserNotFound;
      case 'operation-not-allowed':
        return FirebaseAuthResultStatus.OperationNotAllowed;
      case 'too-many-requests':
        return FirebaseAuthResultStatus.TooManyRequests;
      case 'email-already-exists':
        return FirebaseAuthResultStatus.EmailAlreadyExists;
      default:
        return FirebaseAuthResultStatus.Undefined;
    }
  }

  void showErrorDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(message!),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
  // void initializing(){}

  Future<void> attempAutoLogin() async {
    final res = CommonResponse<User>();
    final auth.User? firebaseUser =
        await auth.FirebaseAuth.instance.authStateChanges().first;
    print(firebaseUser?.uid);
    final CommonResponse<User>? userResponce;

    try {
      if (firebaseUser != null) {
        _read(loginLifeCycleState.notifier).state = LoginLifeCycle.login;
        userResponce = await _read(userRepository).getUser(firebaseUser.uid);
      } else {
        _read(loginLifeCycleState.notifier).state = LoginLifeCycle.initializing;
        userResponce = null;
        return;
      }

      if (userResponce.hasData) {
        _read(loginUserState.notifier).state = userResponce.data;
        _read(firebaseUserState.notifier).state = firebaseUser;
        _read(routeController).push(AppRoute.home);
        return;
      } else {
        print(userResponce.data?.role);
      }
    } on FirebaseException catch (e) {
      print(e.code);
      _read(firebaseAuthResultStatus.notifier).state = handleException(e);
      return;
    }
    // else {
    //   print('${userResponce.errorReason}:error');
    //   // return showErrorDialog(context, message)
    // }
  }

  // void _emailVerify() {}
  // void _passwordVerify() {}

  Future<void> login() async {
    try {
      auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _read(mailAddress.notifier).state,
        password: _read(password.notifier).state,
      );
      if (userCredential.user != null) {
        print('succeed');
        _read(firebaseAuthResultStatus.notifier).state =
            FirebaseAuthResultStatus.Successful;
      } else {
        _read(firebaseAuthResultStatus.notifier).state =
            FirebaseAuthResultStatus.Undefined;
      }
    } on auth.FirebaseAuthException catch (e) {
      print(e.code);
      _read(firebaseAuthResultStatus.notifier).state = handleException(e);
      return;
    }
    attempAutoLogin();
  }

  Future<void> createAccount() async {
    try {
      final auth.User? firebaseUser;
      final DocumentReference ref;
      auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _read(mailAddress.notifier).state,
        password: _read(password.notifier).state,
      );
      if (userCredential.user != null) {
        print('succeed');
        firebaseUser = userCredential.user;
        ref = FirebaseFirestore.instance
            .collection(Collection.user.key)
            .doc(firebaseUser!.uid);
        _read(firebaseAuthResultStatus.notifier).state =
            FirebaseAuthResultStatus.Successful;
            
        await ref.set(const User(role: 'customer').toJson());
      } else {
        _read(firebaseAuthResultStatus.notifier).state =
            FirebaseAuthResultStatus.Undefined;
      }
    } on auth.FirebaseException catch (e) {
      print(e.code);
      _read(firebaseAuthResultStatus.notifier).state = handleException(e);
      return;
    }
    attempAutoLogin();
  }

  String? validateEmail(String? email) {
    RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email == null || email.isEmpty) {
      return 'メールアドレスが未設定です';
    } else if (!regex.hasMatch(email)) {
      return 'メールアドレスが不正です';
    }
  }
  String? validatePassword(String? email) {
    if (email == null || email.isEmpty) {
      return 'パスワードが未設定です';
    } else if (email.trim().contains('　') || email.trim().contains(' ')) {
      return '空文字は入力できません';
    }
  }
}
