import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
typedef AppUserSqlAccess = SqlAccess<Map<String, String>, UserPhone>;
///
///
class AppUser {
  late String id;
  late String group;
  late String location;
  late String name;
  late String phone;
  late String pass;
  late String account;
  late String created;
  late String updated;
  late String deleted;
  final AppUserSqlAccess _remote;
  bool _exists = false;
  ///
  ///
  AppUser({
    required AppUserSqlAccess remote, 
  }) :
    _remote = remote {
      _init();
  }
  /// Returns same instance
  /// - kipping remote
  /// - clearing user's data
  AppUser clear() {
    return AppUser(remote: _remote);
  }
  ///
  ///
  void _init() {
    id = '';
    group = '';
    location = '';
    name = '';
    phone = '';
    pass = '';
    account = '';
    created = '';
    updated = '';
    deleted = '';
  }
  //
  //
  @override
  String toString() {
    var str = '';
    str += "id: '$id'";
    str += "group: '$group'";
    str += "location: '$location'";
    str += "name: '$name'";
    str += "phone: '$phone'";
    str += "pass: '$pass'";
    str += "account: '$account'";
    str += "created: '$created'";
    str += "updated: '$updated'";
    str += "deleted: '$deleted'";    
    return str;
  }
  /// Возвращает true после загруз пользователя из базы
  /// если пользователь в базе есть, false если его там нет
  /// Возвращает null если еще не загружен
  bool get exists => _exists;
  ///
  ///
  Future<Result<AppUser, Failure>> fetch(UserPhone userPhone) {
    return _remote.fetch(params: userPhone).then(
      (result) {
        switch (result) {
          case Ok(:final value):
            if (value.isNotEmpty) {
              final userRow = value.first;
              if (userRow['id'] != null) {
                _exists = false;
                return Err(Failure(message: 'AppUser.fetch | Error: User with $userPhone is not found', stackTrace: StackTrace.current));
              } else {
                id = userRow['id'] ?? '';
                group = userRow['group'] ?? '';
                location = userRow['location'] ?? '';
                name = userRow['name'] ?? '';
                phone = userRow['phone'] ?? '';
                pass = userRow['pass'] ?? '';
                account = userRow['account'] ?? '';
                created = userRow['created'] ?? '';
                updated = userRow['updated'] ?? '';
                deleted = userRow['deleted'] ?? '';
                return Ok(this);
              }
            } else {
              _exists = false;
              return Err(Failure(message: 'AppUser.fetch | Error: User with $userPhone is not found', stackTrace: StackTrace.current));
            }
          case Err(:final error):
            _exists = false;
            return Err(Failure(message: 'AppUser.fetch | Error: $error', stackTrace: StackTrace.current));
        }
      },
      onError: (err) {
        _exists = false;
        return Err(Failure(message: 'AppUser.fetch | Error: $err', stackTrace: StackTrace.current));
      }
    );
  }
}
