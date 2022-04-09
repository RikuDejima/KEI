import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:key/entity/store.dart';
import 'package:key/entity/user.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/repository/base_repository.dart';
import 'package:key/logic/repository/store_repository.dart';
import 'package:key/logic/repository/user_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/state/common/login_user_state.dart';
import 'package:flutter/material.dart';
import 'package:key/logic/state/common/store_state.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final rootViewController = Provider((ref) => RootViewController(ref.read));

enum FirebaseResultStatus {
  Successful,
  EmailAlreadyExists,
  WrongPassword,
  InvalidEmail,
  UserNotFound,
  UserDisabled,
  OperationNotAllowed,
  TooManyRequests,
  Weakpassword,
  Undefined,
}

enum LoginLifeCycle {
  initializing,
  register,
  login,
}

extension FirebaseAuthResultStatusExt on FirebaseResultStatus {
  String exceptionMessage(WidgetRef ref) {
    String? message = '';
    switch (this) {
      case FirebaseResultStatus.Successful:
        message = 'ログインに成功しました。';
        break;
      case FirebaseResultStatus.EmailAlreadyExists:
        message = '指定されたメールアドレスは既に使用されています。';
        break;
      case FirebaseResultStatus.WrongPassword:
        message = 'メールアドレスまたはパスワードが間違っています';
        break;
      case FirebaseResultStatus.InvalidEmail:
        message = 'メールアドレスまたはパスワードが間違っています';
        break;
      case FirebaseResultStatus.UserNotFound:
        message = '指定されたユーザーは存在しません。';
        break;
      case FirebaseResultStatus.UserDisabled:
        message = '指定されたユーザーは無効です。';
        break;
      case FirebaseResultStatus.OperationNotAllowed:
        message = '指定されたユーザーはこの操作を許可していません。';
        break;
      case FirebaseResultStatus.TooManyRequests:
        message = '指定されたユーザーはこの操作を許可していません。';
        break;
      case FirebaseResultStatus.Weakpassword:
        message = 'パスワードが弱いです';
        break;
      case FirebaseResultStatus.Undefined:
        if (ref.read(loginLifeCycleState) == LoginLifeCycle.initializing) {
          message = 'ログインできませんでした';
        } else {
          print(ref.read(loginLifeCycleState.notifier).state);
          message = 'アカウントを作成できませんでした';
        }
        break;
    }
    return message;
  }
}

final firebaseResultStatus =
    StateProvider<FirebaseResultStatus?>((ref) => null);
final loginLifeCycleState =
    StateProvider<LoginLifeCycle>((ref) => LoginLifeCycle.initializing);
final mailAddress = StateProvider<String>((ref) => '');
final password = StateProvider<String>((ref) => '');
final verifyMessage = StateProvider<String>((ref) => '');

class RootViewController {
  final Reader _read;
  RootViewController(this._read);

  FirebaseResultStatus handleException(FirebaseException e) {
    switch (e.code) {
      case 'invalid-email':
        return FirebaseResultStatus.InvalidEmail;
      case 'wrong-password':
        return FirebaseResultStatus.WrongPassword;
      case 'user-disabled':
        return FirebaseResultStatus.UserDisabled;
      case 'user-not-found':
        return FirebaseResultStatus.UserNotFound;
      case 'operation-not-allowed':
        return FirebaseResultStatus.OperationNotAllowed;
      case 'too-many-requests':
        return FirebaseResultStatus.TooManyRequests;
      case 'email-already-exists':
        return FirebaseResultStatus.EmailAlreadyExists;
      case 'weak-password':
        return FirebaseResultStatus.Weakpassword;
      default:
        return FirebaseResultStatus.Undefined;
    }
  }

  void showErrorDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message!),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
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
    final CommonResponse<Store>? storeResponce;

    try {
      if (firebaseUser != null) {
        _read(loginLifeCycleState.notifier).state = LoginLifeCycle.login;
        userResponce = await _read(userRepository).getUser(firebaseUser.uid);
        storeResponce = await _read(storeRepository).getStore(firebaseUser.uid); 
      } else {
        _read(loginLifeCycleState.notifier).state = LoginLifeCycle.initializing;
        userResponce = null;
        return;
      }

      if(storeResponce.hasData){
        _read(storeDataState.notifier).state = storeResponce.data;
      }

      if (userResponce.hasData) {
        _read(loginUserState.notifier).state = userResponce.data;
        _read(firebaseUserState.notifier).state = firebaseUser;
        _read(routeController).replace(AppRoute.home);
        return;
      } 
      _read(firebaseResultStatus.notifier).state =
          FirebaseResultStatus.Successful;
    } on FirebaseException catch (e) {
      print(e.code);
      _read(firebaseResultStatus.notifier).state = handleException(e);
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
        _read(firebaseResultStatus.notifier).state =
            FirebaseResultStatus.Successful;
      } else {
        _read(firebaseResultStatus.notifier).state =
            FirebaseResultStatus.Undefined;
      }
    } on auth.FirebaseAuthException catch (e) {
      print(e.code);
      _read(firebaseResultStatus.notifier).state = handleException(e);
      return;
    }
    attempAutoLogin();
  }

  Future<void> createAccount() async {
    try {
      final auth.User? firebaseUser;
      final DocumentReference doc;
      auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _read(mailAddress.notifier).state.trim(),
        password: _read(password.notifier).state.trim(),
      );
      if (userCredential.user != null) {
        print('succeed');
        firebaseUser = userCredential.user;
        doc = FirebaseFirestore.instance
            .collection(Collection.user.key)
            .doc(firebaseUser!.uid);
        _read(firebaseResultStatus.notifier).state =
            FirebaseResultStatus.Successful;
        const user = User();
        await doc.set(user.toJson());
      } else {
        _read(firebaseResultStatus.notifier).state =
            FirebaseResultStatus.Undefined;
      }
    } on auth.FirebaseException catch (e) {
      print(e.code);
      print('password:${_read(password.notifier).state}');
      _read(firebaseResultStatus.notifier).state = handleException(e);
      return;
    }
    attempAutoLogin();
  }

  String? validateEmail(String? email) {
    final trimedEmail = email?.trim();
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (trimedEmail == null || trimedEmail.isEmpty) {
      return 'メールアドレスが未設定です';
    } else if (!regex.hasMatch(trimedEmail)) {
      return 'メールアドレスが不正です';
    }
  }

  String? validatePassword(String? password) {
    final trimedPassword = password?.trim();
    RegExp regex = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{10,}$');
    if (password == null || password.isEmpty) {
      return 'パスワードが未設定です';
    } else if (password.length < 10) {
      return '英数小文字大文字混在で10文字以上にして下さい';
    }
  }
}
