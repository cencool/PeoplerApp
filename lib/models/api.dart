import 'package:http/http.dart' as http;
import 'package:peopler/models/credentials.dart';

class Api {
  static const String restUrl = 'http://peopler.localhost:8000/v1/person';
  static const String loginUrl = 'http://peopler.localhost:8000/site/get-token';
  static Future<http.Response> getPersons({String query = ''}) async {
    final String url = restUrl + query;
    final String authString = await Credentials.getAuthString();
    return http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
  }

  static Future<http.Response> deletePerson({required int id}) async {
    final String url = '$restUrl/$id';
    final String authString = await Credentials.getAuthString();
    return http.delete(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
  }
}
