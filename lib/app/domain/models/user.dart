import 'package:flutter/material.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/repositories/user_repository.dart';
import 'package:peopler/app/data/services/storage_service.dart';

class User {
  final String id;
  String password = '';
  String token = '';
  bool isLoggedIn = false;

  User({required this.id});

  Future<Result<bool, String>> login() async {
    Result<String, String> tokenResult =
        await UserRepository().getToken(id: id, password: password);
    if (tokenResult is Failure) {
      debugPrint('User.login: ${(tokenResult as Failure).error}');
      return Failure((tokenResult as Failure).error);
    }
    token = (tokenResult as Success).value;
    debugPrint('User.login: received Token is: $token');
    Result<bool, String> saveResult = await UserRepository().saveCredentials(id: id, token: token);
    if (saveResult is Success) {
      isLoggedIn = true;
      return const Success(true);
    }
    debugPrint('User.login : ${(saveResult as Failure).error}');
    return Failure((saveResult as Failure).error);
  }

  static Future<User?> autoLogin() async {
    ///TODO: use userRepository instead
    Result<String, String> idResult = await StorageService().getSharedPrefString('userName');
    if (idResult is Failure) return null;
    Result<String, String> tokenResult = await StorageService().getSharedPrefString('peoplerToken');
    if (tokenResult is Failure) return null;
    User user = User(id: (idResult as Success).value);
    user.token = (tokenResult as Success).value;
    user.isLoggedIn = true;
    debugPrint('User.autoLogin: logged in as ${(user.id)}');
    return user;
  }
}
