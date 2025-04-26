import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/services/api_config.dart';
import 'package:peopler/app/data/services/api_service.dart';
import 'package:peopler/app/data/services/storage_service.dart';
import 'package:peopler/app/data/services/yii_api_service.dart';

class AuthRepository {
  final Ref ref;
  final ApiService _apiService;
  final StorageService storageService;

  AuthRepository(this.ref, {ApiService? apiService, StorageService? storageService})
      : _apiService = apiService ?? YiiApiService(),
        storageService = storageService ?? StorageService();

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
    await storageService.removeSharedPrefString('peoplerToken');
    await storageService.removeSharedPrefString('userName');
    var tokenResult = await storageService.setSharedPrefString('peoplerToken', token);
    var userNameResult = await storageService.setSharedPrefString('userName', id);
    if (tokenResult is Success && userNameResult is Success) {
      return const Success(true);
    }
    return const Failure('Failed to save credentials');
  }

  Future<Result<String, String>> getSharedPrefString(String key) async {
    return storageService.getSharedPrefString(key);
  }

  Future<Result<bool, String>> setSharedPrefString(String key, String value) async {
    return await storageService.setSharedPrefString(key, value);
  }

  Future<Result<bool, String>> deleteCredentials() async {
    var result1 = await storageService.removeSharedPrefString('peoplerToken');

    if (result1 case Failure(error: final error)) {
      return Failure(error);
    }
    var result2 = await storageService.removeSharedPrefString('userName');
    if (result2 case Failure(error: final error)) {
      return Failure(error);
    }
    return const Success(true);
  }
}
