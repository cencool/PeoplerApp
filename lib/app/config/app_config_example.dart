import 'package:peopler/app/data/services/api_service.dart';
import 'package:peopler/app/data/services/yii_api_service.dart';

enum ApiSource { local, remote }

enum PersonListType { pluto, sfgrid }

class AppConfig {
  static ApiSource apiSource = ApiSource.local;
  static String getApiSource() {
    switch (AppConfig.apiSource) {
      case ApiSource.local:
        return 'http://localhost:8000/myapp';
      case ApiSource.remote:
        return 'https://123.456.245.80/myapp';
    }
  }

  static ApiService apiService = YiiApiService();
  static PersonListType personListType = PersonListType.pluto;
}
