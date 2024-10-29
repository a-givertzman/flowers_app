import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
/// Sql parameters used in the RegisterUserSqlAccess.sqlBuilder
class RegisterUserSqlParams {
  final String? id;
  final String? role;
  final String? email;
  final String? phone;
  final String? name;
  final String? location;
  final String? login;
  final String? pass;
  final String? account;
  final String? lastAct;
  final String? blocked;
  ///
  /// [id] - customer id
  RegisterUserSqlParams({
    this.id,
    this.role,
    this.email,
    this.phone,
    this.name,
    this.location,
    this.login,
    this.pass,
    this.account,
    this.lastAct,
    this.blocked,
  });
}
///
///
typedef RegisterUserSqlAccess = SqlAccess<Map<String, dynamic>, RegisterUserSqlParams>;
///
/// Registering and creating a new user in the database
class RegisterUser {
  static const _log = Log('RegisterUser');
  final RegisterUserSqlAccess? _remote;
  final AppUser _user;
  ///
  /// Registering and creating a new user in the database
  /// - [remote] - [RegisterUserSqlAccess]? - not required, but can be specified if default is not suitable
  RegisterUser({
    required AppUser user,
    RegisterUserSqlAccess? remote,
  }) :
    _user = user,
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        return Sql(sql: """
          insert into public.customer as cu ('role', email, phone, 'name', 'location', 'login', pass, account, last_act, blocked) 
              values (${params?.role}, ${params?.email}, ${params?.phone}, ${params?.name}, _${params?.location}, ${params?.login}, ${params?.pass}, ${params?.account}, ${params?.lastAct}, ${params?.blocked})
              on conflict (customer_id, purchase_item_id) do update 
                set role = _role,
                set email = _email,
                set phone = _phone,
                set name = _name,
                set location = _location,
                set login = _login,
                set pass = _pass,
                set account = _account,
                set lastAct = _last_act,
                set blocked = _blocked
              where cu.id = ${params?.id};
        """,);
      },
      entryBuilder: (row) {
        return row;
      },
    );

  ///
  ///
  ///
  /// Returns PurchaseItem by it database ID
  Future<Result<AppUser, Failure>> fetch(RegisterUserSqlParams? params) {
    final params_ = RegisterUserSqlParams(
      role: params?.role ?? _user.role,
      email: params?.email ?? _user.email,
      phone: params?.phone ?? _user.phone,
      name: params?.name ?? _user.name,
      location: params?.location ?? _user.location,
      login: params?.login ?? _user.login,
      pass: params?.pass ?? _user.pass,
      account: params?.account ?? _user.account,
      lastAct: params?.lastAct ?? _user.lastAct,
      blocked: params?.blocked ?? _user.blocked,
    );
    final remote = _remote;
    if (remote != null) {
      return remote.fetch(params: params_).then(
        (result) {
          switch (result) {
            case Ok(:final value):
              _log.debug('.fetch | result: $value');
              if (value.isNotEmpty) {
                // final row = value.first;
                return Ok(_user);
              } else {
                return Err(Failure(message: 'RegisterUser.fetch | Error Register User with params: $params_', stackTrace: StackTrace.current));
              }
            case Err(:final error):
              _log.warning('.fetch | Error: $error');
              return Err(Failure(message: 'RegisterUser.fetch | Error: $error', stackTrace: StackTrace.current));
          }
        },
        onError: (err) {
          _log.warning('.fetch | Error: $err');
          return Err(Failure(message: 'RegisterUser.fetch | Error: $err', stackTrace: StackTrace.current));
        },
      );
    } else {
      return Future.value(Err(Failure(message: 'RegisterUser.fetch | Error: _remote is not initilized', stackTrace: StackTrace.current)));
    }
  }
}
