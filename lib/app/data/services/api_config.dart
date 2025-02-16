class ApiConfig {
  // static const String baseUrl = 'https://70.34.245.80/peopler';
  static const String baseUrl = 'http://peopler.localhost:8000';
  static const String personUrl = '$baseUrl/v1/person';
  static const String personPhotoReceiveUrl = '$baseUrl/v1/photo/send-photo';
  static const String personPhotoSendUrl = '$baseUrl/v1/photo/receive-photo';
  static const String personDetailUrl = '$baseUrl/v1/person-detail';
  static const String loginUrl = '$baseUrl/site/get-token';
  static const String relationUrl = '$baseUrl/v1/relation';
  static const String relationNamesUrl = '$baseUrl/v1/relation/relation-names';
  static const String relationRecordUrl = '$baseUrl/v1/relation/view-relation';
  static const String personSearchUrl = '$baseUrl/v1/person/search';
  static const String attachmentUrl = '$baseUrl/v1/attachment';
  static const String itemUrl = '$baseUrl/v1/item';
}
