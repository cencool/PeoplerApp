import 'package:peopler/app/config/app_config.dart';

class ApiConfig {
  static String baseUrl = AppConfig.getApiSource();
  static String personUrl = '$baseUrl/person';
  static String personPhotoReceiveUrl = '$baseUrl/send-photo';
  static String personPhotoSendUrl = '$baseUrl/receive-photo';
  static String personDetailUrl = '$baseUrl/person-detail';
  static String loginUrl = '$baseUrl/get-token';
  static String relationUrl = '$baseUrl/relation';
  static String relationNamesUrl = '$baseUrl/relation-names';
  static String relationRecordUrl = '$baseUrl/view-relation';
  static String personSearchUrl = '$baseUrl/person/search';
  static String attachmentUrl = '$baseUrl/attachment';
  static String itemUrl = '$baseUrl/item';
}
