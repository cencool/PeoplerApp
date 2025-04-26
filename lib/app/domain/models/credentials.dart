import 'dart:convert';

class Credentials {
  final String userName;
  late final String token;

  Credentials({required this.userName, required this.token});

  @override
  String toString() {
    return 'Credentials{username: $userName, token: $token}';
  }

  String getAuthString() {
    var authBytes = utf8.encode(
        '$token:'); // colon is necessary to append for basic auth to work becaus Yii use only user part as token!
    return base64Encode(authBytes); // create token for basic auth
  }
}
