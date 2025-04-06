import 'package:flutter/material.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/repositories/user_repository.dart';

class User {
  final String id;
  String password = '';
  String token = '';
  bool isLoggedIn = false;

  User({required this.id});

  Future<Result<bool, String>> login({UserRepository? repository}) async {
    UserRepository userRepo = repository ?? UserRepository();

    Result<String, String> tokenResult = await userRepo.getToken(id: id, password: password);
    switch (tokenResult) {
      case Success(value: final value):
        token = value;
        break;
      case Failure(error: final error):
        debugPrint('User.login: $error');
        return Failure(error);
    }
    debugPrint('User.login: received Token is: $token');
    Result<bool, String> saveResult = await userRepo.saveCredentials(id: id, token: token);
    switch (saveResult) {
      case Success(value: final value):
        isLoggedIn = true;
        return const Success(true);
      case Failure(error: final error):
        debugPrint('User.login : $error');
        return Failure(error);
    }
  }

  static Future<User?> autoLogin({UserRepository? repository}) async {
    UserRepository userRepo = repository ?? UserRepository();

    Result<String, String> idResult = await userRepo.getSharedPrefString('userName');
    switch (idResult) {
      case Failure(error: _):
        return null;
      case Success(value: final id):
        Result<String, String> tokenResult = await userRepo.getSharedPrefString('peoplerToken');
        switch (tokenResult) {
          case Failure(error: _):
            return null;
          case Success(value: final token):
            User user = User(id: id);
            user.token = token;
            user.isLoggedIn = true;
            debugPrint('User.autoLogin: logged in as ${user.id}');
            return user;
        }
    }
  }
}
