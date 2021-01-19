
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  String get serviceUrl {
    final data = _getFromDisk('service-url');
    if (data == null) return 'http://10.0.2.2:3000/v1';
    return data;
  }

  set serviceUrl(String serviceUrl) {
    saveStringToDisk('service-url', serviceUrl);
  }

  dynamic _getFromDisk(String key) {
    final value = _preferences.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void saveStringToDisk(String key, String value){
    print('(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $value');
    _preferences.setString(key, value);
  }
}