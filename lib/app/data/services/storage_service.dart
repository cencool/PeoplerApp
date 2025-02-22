import 'package:peopler/app/core/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<Result<String, String>> getSharedPrefString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    if (value == null) {
      return const Failure('Key not found');
    }
    return Success(value);
  }

  Future<Result<bool, String>> setSharedPrefString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString(key, value);
    if (result) {
      return const Success(true);
    }
    return const Failure('Failed to set value');
  }

  Future<Result<bool, String>> removeSharedPrefString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.remove(key);
    if (result) {
      return const Success(true);
    }
    return const Failure('Failed to remove value');
  }
}
