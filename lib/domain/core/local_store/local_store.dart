import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Класс реализует чтение и запись данных
/// простых типов в локальное хранилище
/// так же поддерживает шифрование данных 
/// в юникод utf8 и затем в base64 string 
class LocalStore {
  LocalStore();
  Future<SharedPreferences> _getPrefs() {
    return SharedPreferences
      .getInstance()
      .then(
        (prefs) => prefs
      );
  }
  Future<String> readString(String key) {
    return _getPrefs().then((prefs) {
      final value = prefs.getString(key) ?? '';
      return decodeStr(value);
    });
  }
  Future<bool> writeString(String key, String value) {
    return _getPrefs().then((prefs) {
      return prefs.setString(key, encodeStr(value));
    });
  }
  Future<bool> remove(String key) {
    return _getPrefs().then((prefs) {
      return prefs.remove(key);
    });
  }
  String encodeStr(String value) {
    final bytes = utf8.encode(value);
    final base64Str = base64.encode(bytes);
    print('[encodeStr] base64Str: $base64Str');
    return base64Str;
  }
  String decodeStr(String value) {
    final b64 = base64.decode(value);
    final str = utf8.decode(b64);
    print('[decodeStr] str: $str');
    return str;
  }
}