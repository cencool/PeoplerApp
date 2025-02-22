import 'package:peopler/app/config/app_config.dart';

class ApiConfig {
  static String baseUrl = AppConfig.getApiSource();
  static String personUrl = '$baseUrl/v1/person';
  static String personPhotoReceiveUrl = '$baseUrl/v1/photo/send-photo';
  static String personPhotoSendUrl = '$baseUrl/v1/photo/receive-photo';
  static String personDetailUrl = '$baseUrl/v1/person-detail';
  static String loginUrl = '$baseUrl/site/get-token';
  static String relationUrl = '$baseUrl/v1/relation';
  static String relationNamesUrl = '$baseUrl/v1/relation/relation-names';
  static String relationRecordUrl = '$baseUrl/v1/relation/view-relation';
  static String personSearchUrl = '$baseUrl/v1/person/search';
  static String attachmentUrl = '$baseUrl/v1/attachment';
  static String itemUrl = '$baseUrl/v1/item';
}
