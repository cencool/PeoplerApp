import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/services/api_config.dart';
import 'package:peopler/app/data/services/api_service.dart';
import 'package:peopler/app/data/services/storage_service.dart';
import 'package:peopler/app/data/services/yii_api_service.dart';

class UserRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  UserRepository({ApiService? apiService, StorageService? storageService})
      : _apiService = apiService ?? YiiApiService(),
        _storageService = storageService ?? StorageService();

  Future<Result<String, String>> getToken({required String id, required String password}) async {
    Result<http.Response, String> result = await _apiService.postRequest(
        Uri.parse(ApiConfig.loginUrl),
        body: jsonEncode({"user": id, "password": password}),
        headers: {
          "Content-Type": "application/json",
        });

    switch (result) {
      case Success(value: final response):
        var body = jsonDecode(response.body);
        if (body is Map && body['token'] != null) {
          return Success(body['token'] as String);
        }
        return const Failure('Invalid Token response format');
      case Failure(error: final error):
        return Failure(error);
    }
  }

  Future<Result<bool, String>> saveCredentials({required String id, required String token}) async {
    await _storageService.removeSharedPrefString('peoplerToken');
    await _storageService.removeSharedPrefString('userName');
    var tokenResult = await _storageService.setSharedPrefString('peoplerToken', token);
    var userNameResult = await _storageService.setSharedPrefString('userName', id);
    if (tokenResult is Success && userNameResult is Success) {
      return const Success(true);
    }
    return const Failure('Failed to save credentials');
  }

  Future<Result<String, String>> getSharedPrefString(String key) async {
    return _storageService.getSharedPrefString(key);
  }

  Future<Result<bool, String>> setSharedPrefString(String key, String value) async {
    return await _storageService.setSharedPrefString(key, value);
  }
}
