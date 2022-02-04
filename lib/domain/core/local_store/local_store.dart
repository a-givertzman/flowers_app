import 'dart:convert';

import 'package:flowers_app/dev/log/log.dart';
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
        (prefs) => prefs,
      );
  }
  Future<String> readString(String key) {
    return _getPrefs().then((prefs) {
      final value = prefs.getString(key) ?? '';
      log('[LocalStore.readString] key: $key;\tvalue: $value');
      return decodeStr(value);
    });
  }
  Future<bool> writeString(String key, String value) {
    return _getPrefs().then((prefs) {
      return prefs.setString(key, encodeStr(value)).then((value) {
        log('[LocalStore.writeString] key: $key;\tvalue: $value');
        return value;
      });
    });
  }
  Future<bool> remove(String key) {
    return _getPrefs().then((prefs) {
      return prefs.remove(key).then((value) {
        log('[LocalStore.remove] deleted key: $key');
        return value;
      });
    });
  }
  String encodeStr(String value) {
    final bytes = utf8.encode(value);
    final base64Str = base64.encode(bytes);
    log('[LocalStore.encodeStr] str: $value to $base64Str');
    return base64Str;
  }
  String decodeStr(String value) {
    final b64 = base64.decode(value);
    final str = utf8.decode(b64);
    log('[LocalStore.decodeStr] value: $value to $str');
    return str;
  }
}
