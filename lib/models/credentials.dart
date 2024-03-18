import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peopler/models/api.dart';
import 'package:http/http.dart' as http;

class Credentials {
  /* bude ukladat a citat api key z uloziska, 
  aktualizovat, ci sa zmenil login 
  { 'loggedIn': true/false, 'token': null/string}
  */

  static Future<bool> login({required String userName, required String password}) async {
    // skusi login a ulozit status a token do persistent...
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    final bodyData = {'user': userName, 'password': password};
    final response = await http.post(
      Uri.parse(Api.loginUrl),
      body: bodyData,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = jsonDecode(response.body);
      if (responseData['token'] != null) {
        prefs.setString('token', responseData['token']);
        final token = prefs.getString('token');
        debugPrint('Token is: $token');
        return true;
      }
    }
    return false;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> isLoggedIn() async {
    if (await getToken() != null) {
      return true;
    }
    return false;
  }

  static Future<String> getAuthString() async {
    final token = await getToken() ?? '';
    final authBytes = utf8.encode('$token:'); // colon is necessary to append!
    return base64Encode(authBytes); // create token for basic auth
  }

  static deleteToken() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
    });
  }
}
