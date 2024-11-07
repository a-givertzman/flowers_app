import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result.dart';
// ignore: avoid_classes_with_only_static_members
///
///
class AppSettings {
  static const _log = Log('AppSettings');
  static final _map = <String, dynamic>{
    'displaySizeWidth': 1024,
    'displaySizeHeight': 768,
    // Place Durations in milliseconds!
    'flushBarDurationLong': 8000,
    'flushBarDurationMedium': 4000,
    'flushBarDurationShort': 2000,
    'smallPadding': 4.0,
    'padding': 8.0,
    'blockPadding': 16.0,
    'floatingActionButtonSize': 60.0,
    'floatingActionIconSize': 45.0,
  };
  ///
  static Future<void> initialize({JsonMap<dynamic>? jsonMap}) async {
    if (jsonMap != null) {
      await jsonMap.decoded
        .then((result) {
          // _log.debug('.initialize | Result: $result');
          return switch(result) {
            Ok(value: final map) => _map.addAll(map),
            Err(: final error) => _log.warning('Failed to initialize app settings from file. Error: $error'),
          };
        },);
    }
  }
  ///
  static dynamic getSetting(String settingName) {
    final setting = _map[settingName];
    if (setting == null) {
      throw Failure(
        message: 'Ошибка в методе $AppSettings.getSetting(): Не найдена настройка "$settingName"',
        stackTrace: StackTrace.current,
      );
    }
    return setting;
  }
}
