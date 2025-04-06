import 'package:peopler/app/data/services/api_service.dart';
import 'package:peopler/app/core/result.dart';
import 'package:http/http.dart' as http;

class YiiApiService implements ApiService {
  final http.Client _client;

  YiiApiService([http.Client? client]) : _client = client ?? http.Client();

  @override
  Future<Result<http.Response, String>> getRequest(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await _client.get(uri, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(response);
      } else {
        return Failure('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Result<http.Response, String>> postRequest(Uri uri,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final response = await _client.post(
        uri,
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
