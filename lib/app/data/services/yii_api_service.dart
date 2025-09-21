import 'dart:async'; // Added for TimeoutException and .timeout()
import 'dart:io'; // Added for SocketException

import 'package:peopler/app/data/services/api_service.dart';
import 'package:peopler/app/core/result.dart';
import 'package:http/http.dart' as http;

const Duration defaultTimeoutDuration = Duration(seconds: 15); // Define a default timeout

class YiiApiService implements ApiService {
  final http.Client _client;

  YiiApiService([http.Client? client]) : _client = client ?? http.Client();

  @override
  Future<Result<http.Response, String>> getRequest(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response =
          await _client.get(uri, headers: headers).timeout(defaultTimeoutDuration); // Added timeout

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(response);
      } else {
        return Failure('HTTP Error: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      // Specific catch for TimeoutException
      return Failure(
          'Request timed out after ${defaultTimeoutDuration.inSeconds} seconds: ${e.toString()}');
    } on SocketException catch (e) {
      // Specific catch for SocketException
      return Failure('Network connection error: ${e.toString()}');
    } catch (e) {
      // General catch for other errors
      return Failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Result<http.Response, String>> postRequest(Uri uri,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final response = await _client
          .post(
            uri,
            headers: headers,
            body: body,
          )
          .timeout(defaultTimeoutDuration); // Added timeout

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(response);
      } else {
        return Failure('HTTP Error: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      // Specific catch for TimeoutException
      return Failure(
          'Request timed out after ${defaultTimeoutDuration.inSeconds} seconds: ${e.toString()}');
    } on SocketException catch (e) {
      // Specific catch for SocketException
      return Failure('Network connection error: ${e.toString()}');
    } catch (e) {
      // General catch for other errors
      return Failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Result<http.Response, String>> putRequest(Uri uri,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final response = await _client
          .put(
            uri,
            headers: headers,
            body: body,
          )
          .timeout(defaultTimeoutDuration); // Added timeout

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(response);
      } else {
        return Failure('HTTP Error: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      // Specific catch for TimeoutException
      return Failure(
          'Request timed out after ${defaultTimeoutDuration.inSeconds} seconds: ${e.toString()}');
    } on SocketException catch (e) {
      // Specific catch for SocketException
      return Failure('Network connection error: ${e.toString()}');
    } catch (e) {
      // General catch for other errors
      return Failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Result<http.Response, String>> deleteRequest(Uri uri,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final response = await _client
          .put(
            uri,
            headers: headers,
            body: body,
          )
          .timeout(defaultTimeoutDuration); // Added timeout

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(response);
      } else {
        return Failure('HTTP Error: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      // Specific catch for TimeoutException
      return Failure(
          'Request timed out after ${defaultTimeoutDuration.inSeconds} seconds: ${e.toString()}');
    } on SocketException catch (e) {
      // Specific catch for SocketException
      return Failure('Network connection error: ${e.toString()}');
    } catch (e) {
      // General catch for other errors
      return Failure('Network error: ${e.toString()}');
    }
  }
}
