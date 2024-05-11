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

  static Future<bool> login(
      {required String userName, required String password, required BuildContext context}) async {
    // skusi login a ulozit status a token do persistent...
    late ScaffoldMessengerState messengerRef = ScaffoldMessenger.of(context);
    await deleteToken();
    final prefs = await SharedPreferences.getInstance();
    final bodyData = {'user': userName, 'password': password};
    try {
      final response = await http.post(
        Uri.parse(Api.loginUrl),
        body: bodyData,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        if ((responseData is Map) && responseData['token'] != null) {
          prefs.setString('peoplerToken', responseData['token']);
          final token = prefs.getString('peoplerToken');
          debugPrint('Token is: $token');
          return true;
        }
      }
      return false;
    } on http.ClientException catch (e) {
      debugPrint('Connection error: ${e.message}');
      // if (context.mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(e.message),
      //     duration: const Duration(seconds: 0, milliseconds: 1500),
      //     backgroundColor: Colors.red,
      //   ));
      // }
      messengerRef.showSnackBar(SnackBar(
        content: Text(e.message),
        duration: const Duration(seconds: 0, milliseconds: 1500),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('peoplerToken');
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
    return await (prefs.remove('peoplerToken'));
  }
}
