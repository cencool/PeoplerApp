import 'package:http/http.dart' as http;
import 'package:peopler/app/core/result.dart';

abstract class ApiService {
  Future<Result<http.Response, String>> getRequest(Uri uri, {Map<String, String>? headers});
  Future<Result<http.Response, String>> postRequest(Uri uri,
      {Map<String, String>? headers, Object? body});
}
