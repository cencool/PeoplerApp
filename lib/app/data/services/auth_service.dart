import 'package:flutter/widgets.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/repositories/auth_repository.dart';
import 'package:peopler/app/domain/models/credentials.dart';

class AuthService {
  Future<Result<Credentials, String>> login(
      {required AuthRepository repository,
      required String userName,
      required String password}) async {
    Result<String, String> tokenResult =
        await repository.getToken(id: userName, password: password);
    switch (tokenResult) {
      case Success(value: final value):
        var result = await repository.saveCredentials(id: userName, token: value);
        switch (result) {
          case Success(value: _):
            debugPrint('AuthService.login: saved credentials');
            break;
          case Failure(error: final error):
            debugPrint('AuthService.login: $error');
            return Failure(error);
        }
        return (Success(Credentials(userName: userName, token: value)));
      case Failure(error: final error):
        debugPrint('AuthService.login: $error');
        return Failure(error);
    }
  }

  static Future<Credentials?> autoLogin({required AuthRepository userRepository}) async {
    Result<String, String> idResult = await userRepository.getSharedPrefString('userName');
    switch (idResult) {
      case Failure(error: _):
        return null;
      case Success(value: final id):
        Result<String, String> tokenResult =
            await userRepository.getSharedPrefString('peoplerToken');
        switch (tokenResult) {
          case Failure(error: _):
            return null;
          case Success(value: final token):
            Credentials credentials = Credentials(userName: id, token: token);
            debugPrint('AuthService.autoLogin: logged in as $id');
            return credentials;
        }
    }
  }

  Future<Result<bool, String>> logout({required AuthRepository repository}) async {
    Result<bool, String> result = await repository.deleteCredentials();
    switch (result) {
      case Success(value: _):
        return const Success(true);
      case Failure(error: final error):
        return Failure(error);
    }
  }
}
