import 'package:flowers_app/domain/core/errors/failure.dart';

class UserGroup {
  static const normal = 'normal';
  static const blocked = 'blocked';
  static const banned = 'banned';
  static const vip1 = 'vip1';
  static const vip2 = 'vip2';
  static const vip3 = 'vip3';
  static const admin = 'admin';
  static const manager = 'manager';
}
class UserGroupText {
  final Map<String, String> _statuses = {
    UserGroup.normal: 'Пользователь',
    UserGroup.blocked: 'Заблокирован',
    UserGroup.banned: 'Банн',
    UserGroup.vip1: 'Резерв - VIP1',
    UserGroup.vip2: 'Резерв - VIP2',
    UserGroup.vip3: 'Резерв - VIP3',
    UserGroup.admin: 'Администратор',
    UserGroup.manager: 'Менеджер',
  };
  final String _status;
  UserGroupText({required String status}): _status = status;
  String text() => textOf(_status);
  String textOf(String key) {
    if (_statuses.containsKey(key)) {
      final status = _statuses[key];
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
