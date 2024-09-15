import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class AppUserSqlParams {
  final String? id;
  final String? phone;
  AppUserSqlParams({
    this.id,
    this.phone,
  });
}
///
typedef AppUserSqlAccess = SqlAccess<Map<String, dynamic>, AppUserSqlParams>;
///
/// - [role] - String, [UserGroupList], 'admin', 'manager', 'customer' etc...
/// - [email] -;
/// - [phone] -;
/// - [name] -;
/// - [location] - String, geographical location, the city or some region
/// - [login] -;
/// - [pass] -;
/// - [account] -;
/// - [lastAct] -;
/// - [blocked] - String, timestamp when user whas blocked
class AppUser {
  static const _log = Log('AppUser');
  late String id = '';
  late String role = '';
  late String email = '';
  late String phone = '';
  late String name = '';
  late String location = '';
  late String login = '';
  late String pass = '';
  late String account = '';
  late String lastAct = '';
  late String blocked = '';
  late String created = '';
  late String updated = '';
  late String deleted = '';
  final AppUserSqlAccess _remote;
  bool _exists = false;
  ///
  /// Creates [AppUser] with [id], or can be fetched later by [phone] or another uniq parameter
  AppUser({
    String? id,
    AppUserSqlAccess? remote, 
  }) :
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        if (params?.id != null) {
          return Sql(sql: "select * from customer where id = '${params?.id}';");
        } else if (params?.phone != null) {
          return Sql(sql: "select * from customer where phone = '${params?.phone}';");
        }
        return Sql(sql: "select * from customer where id = '$id';");
      },
      entryBuilder: (row) {
        return row;
      },
    );
  /// Returns same instance
  /// - kipping remote
  /// - clearing user's data
  AppUser clear() {
    return AppUser(remote: _remote);
  }
  //
  //
  @override
  String toString() {
    var str = '';
    str += "id: '$id', ";
    str += "role: '$role', ";
    str += "email: '$email', ";
    str += "phone: '$phone', ";
    str += "name: '$name', ";
    str += "location: '$location', ";
    str += "login: '$login', ";
    str += "pass: '$pass', ";
    str += "account: '$account', ";
    str += "lastAct: '$lastAct', ";
    str += "blocked: '$blocked', ";
    str += "created: '$created', ";
    str += "updated: '$updated', ";
    str += "deleted: '$deleted'";    
    return str;
  }
  ///
  /// Возвращает true после загруз пользователя из базы
  /// если пользователь в базе есть, false если его там нет
  /// Возвращает null если еще не загружен
  bool get exists => _exists;
  ///
  ///
  Result<AppUser, Failure> fromRow(Map<String, dynamic> row) {
    _log.debug(".fromRow |");
    final rowId = row['id'];
    if (rowId == null) {
      _exists = false;
      return Err(Failure(message: 'AppUser.fromRow | Error (id - not found) build User from: $row', stackTrace: StackTrace.current));
    } else {
      if ('$rowId'.isEmpty) {
        _exists = false;
        return Err(Failure(message: 'AppUser.fromRow | Error (id - is empty) build User from $row', stackTrace: StackTrace.current));
      }
      id = '${row['id']}';
      role = '${row['role']}';
      email = '${row['email']}';
      phone = '${row['phone']}';
      name = '${row['name']}';
      location = '${row['location']}';
      login = '${row['login']}';
      pass = '${row['pass']}';
      account = '${row['account']}';
      lastAct = '${row['lastAct']}';
      blocked = '${row['blocked']}';
      created = '${row['created']}';
      updated = '${row['updated']}';
      deleted = '${row['deleted']}';
      _exists = true;
      return Ok(this);
    }
  }
  ///
  ///
  Future<Result<AppUser, Failure>> fetch(AppUserSqlParams params) {
    return _remote.fetch(params: params).then(
      (result) {
        switch (result) {
          case Ok(:final value):
            _log.debug('.fetch | result: $value');
            if (value.isNotEmpty) {
              final row = value.first;
              return fromRow(row);
            } else {
              _exists = false;
              return Err(Failure(message: 'AppUser.fetch | Error: Not found User with params: $params', stackTrace: StackTrace.current));
            }
          case Err(:final error):
            _exists = false;
            return Err(Failure(message: 'AppUser.fetch | Error: $error', stackTrace: StackTrace.current));
        }
      },
      onError: (err) {
        _log.warning('.fetch | Error: $err');
        _exists = false;
        return Err(Failure(message: 'AppUser.fetch | Error: $err', stackTrace: StackTrace.current));
      },
    );
  }
}
