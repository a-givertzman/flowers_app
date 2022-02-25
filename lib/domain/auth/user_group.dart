import 'package:flowers_app/domain/core/errors/failure.dart';

/// Константы групп пользователей в системе
class UserGroupList {
  static const normal = 'normal';
  static const blocked = 'blocked';
  static const banned = 'banned';
  static const vip1 = 'vip1';
  static const vip2 = 'vip2';
  static const vip3 = 'vip3';
  static const admin = 'admin';
  static const manager = 'manager';
}
/// Класс работы с группами пользователей
class UserGroup {
  final Map<String, String> _groups = {
    UserGroupList.normal: 'Пользователь',
    UserGroupList.blocked: 'Заблокирован',
    UserGroupList.banned: 'Банн',
    UserGroupList.vip1: 'Резерв - VIP1',
    UserGroupList.vip2: 'Резерв - VIP2',
    UserGroupList.vip3: 'Резерв - VIP3',
    UserGroupList.admin: 'Администратор',
    UserGroupList.manager: 'Менеджер',
  };
  late String _group;
  UserGroup({required String group}) {
    if (_groups.containsKey(group)) {
      _group = group;
    } else {
      throw Failure.convertion(
          message: "[UserGroup] '$group' несуществующая группа",
          stackTrace: StackTrace.current,
      );
    }
  }
  /// вернет значение группы
  String get value => _group;
  /// вернет текстовое представление группы
  String text() => textOf(_group);
  /// вернет текстовое представление группы переданной в параметре
  String textOf(String key) {
    if (_groups.containsKey(key)) {
      final status = _groups[key];
      if (status != null) {
        return status;
      }
    }
    throw Failure.unexpected(
      message: '[$runtimeType] $key - несуществующая группа',
      stackTrace: StackTrace.current,
    );
  }
}
