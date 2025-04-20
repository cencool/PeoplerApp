class Credentials {
  final String userName;
  late final String token;

  Credentials({required this.userName, required this.token});

  @override
  String toString() {
    return 'Credentials{username: $userName, token: $token}';
  }
}
