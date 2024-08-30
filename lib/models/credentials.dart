import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peopler/models/api.dart';

class Credentials {
  static Future<bool> login({required String userName, required String password}) async {
    await deleteToken();
    final prefs = await SharedPreferences.getInstance();
    final bodyData = {'user': userName, 'password': password};
    var response = await Api.request(
      url: Api.loginUrl,
      callerId: 'Cred.Login',
      method: RequestMethod.post,
      body: json.encode(bodyData),
      headers: {'Content-Type': 'application/json'},
      auth: false,
    );
    if (response != null) {
      final responseData = jsonDecode(response.body);
      if ((responseData is Map) && responseData['token'] != null) {
        await prefs.setString('peoplerToken', responseData['token']);
        await prefs.setString('userName', userName);
        final token = prefs.getString('peoplerToken');
        debugPrint('Token is: $token');
        return true;
      }
    }
    return false;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('peoplerToken');
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');
    if (userName == null) {
      return '';
    }
    return userName;
  }

  static Future<bool> isLoggedIn() async {
    if (await getToken() != null) {
      return true;
    }
    return false;
  }

  static Future<String> getAuthString() async {
    final token = await getToken() ?? '';
    final authBytes =
        utf8.encode('$token:'); // colon is necessary to append for basic auth to work!
    return base64Encode(authBytes); // create token for basic auth
  }

  static Future<bool> deleteToken() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    return await (prefs.remove('peoplerToken'));
  }
}
