import 'package:http/http.dart' as http;
import 'package:peopler/app/core/result.dart';

class ApiService {
  final http.Client _client;

  ApiService([http.Client? client]) : _client = client ?? http.Client();

  Future<Result<http.Response, String>> getRequest(String url,
      {Map<String, String>? headers}) async {
    try {
      final response = await _client.get(Uri.parse(url), headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(response);
      } else {
        return Failure('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }

  Future<Result<http.Response, String>> postRequest(String url,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(response);
      } else {
        return Failure('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }
}
