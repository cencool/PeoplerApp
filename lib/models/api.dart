import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peopler/models/credentials.dart';
import 'package:peopler/widgets/snack_message.dart';

enum RequestMethod { get, post, put, delete }

typedef Headers = Map<String, String>;

class Api {
  // static const String serverUrl = 'http://localhost:8102';
  static const String serverUrl = 'http://peopler.localhost:8000';
  // static const String serverUrl = 'http://192.168.0.34:88/peopler';
  // static const String serverUrl = 'https://70.34.245.80/peopler';
  static const String personRestUrl = '$serverUrl/v1/person';
  static const String personPhotoReceiveUrl = '$serverUrl/v1/photo/send-photo';
  static const String personPhotoSendUrl = '$serverUrl/v1/photo/receive-photo';
  static const String personDetailUrl = '$serverUrl/v1/person-detail';
  static const String loginUrl = '$serverUrl/site/get-token';
  static const String relationUrl = '$serverUrl/v1/relation';
  static const String relationNamesUrl = '$serverUrl/v1/relation/relation-names';
  static const String relationRecordUrl = '$serverUrl/v1/relation/view-relation';
  static const String personSearchUrl = '$serverUrl/v1/person/search';
  static const String attachmentUrl = '$serverUrl/v1/attachment';
  static const String itemUrl = '$serverUrl/v1/item';

  static Future<http.Response?> request({
    String callerId = 'defaultId',
    String url = '',
    RequestMethod method = RequestMethod.get,
    Headers headers = const {},
    String body = '',
    bool auth = true,
  }) async {
    final String authString = await Credentials.getAuthString();
    if (headers.isEmpty && auth) {
      headers = {'Authorization': 'Basic $authString'};
    } else if (auth) {
      headers.addAll({'Authorization': 'Basic $authString'});
    }
    Uri uri = Uri.parse(url);
    http.Request request;
    switch (method) {
      case (RequestMethod.get):
        request = http.Request('get', uri);
      case (RequestMethod.post):
        request = http.Request('post', uri);
        if (body.isNotEmpty) {
          request.bodyBytes = utf8.encode(body);
        }
      case (RequestMethod.put):
        request = http.Request('put', uri);
        if (body.isNotEmpty) {
          request.bodyBytes = utf8.encode(body);
        }
      case (RequestMethod.delete):
        request = http.Request('delete', uri);
      default:
        request = http.Request('get', uri);
    }
    request.headers.addAll(headers);
    try {
      http.StreamedResponse streamedResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        SnackMessage.showMessage(
            message: '$callerId - Unexpected response code:${response.statusCode} ',
            messageType: MessageType.error);
        return null;
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(message: '$callerId, ${e.message}', messageType: MessageType.error);
      return null;
    } catch (e) {
      SnackMessage.showMessage(
          message: 'Exceptions:$callerId,${e.toString()}', messageType: MessageType.error);
      return null;
    }
  }
}
