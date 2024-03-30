class Api {
  // static const String serverUrl = 'http://peopler.localhost:8000';
  static const String serverUrl = 'http://192.168.0.34:88/peopler';
  static const String personRestUrl = '$serverUrl/v1/person';
  static const String personPhotoUrl = '$serverUrl/v1/photo/send-photo';
  static const String personDetailUrl = '$serverUrl/v1/person-detail';
  static const String loginUrl = '$serverUrl/site/get-token';
  static const String relationUrl = '$serverUrl/v1/relation';
}
