import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
Future<void> main(List<String> args) async {
  const debug = false;
  // const phone = '9818771070';
  const phone = '9615258088';
  authenticateByPhoneNumber(phone)
    .then((AuthResult authResult) {
      log(debug, 'authResult: $authResult');
      log(debug, 'authResult: ${authResult.authenticated()}');
      log(debug, 'authResult: ${authResult.message()}');
    });
}
const _storeKey = 'spwd';
final _user = AppUser(
  // remote: SqlAccess(
  //   address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
  //   authToken: const Setting('api-auth-token').toString(),
  //   database: const Setting('api-database').toString(),
  //   sqlBuilder: (sql, userPhone) {
  //     return Sql(sql: "select * from customer where phone = '${userPhone?.numberWithCode}';");
  //   },
  // ),
);
final _localStore = LocalStore();
  Future<AuthResult> authenticateByPhoneNumber(String phoneNumber) {
    const debug = false;
    return _user.fetch(UserPhone(phone: phoneNumber)).then((user) {
      log(debug, 'user: $user');
      switch (user) {
        case Ok(value: final user):
          if (user.exists && user.name != '') {
            _localStore.writeStringEncoded(_storeKey, phoneNumber);
            return AuthResult(
              authenticated: true, 
              message: 'Авторизован успешно',
              user: user,
            );
          } else {
            return AuthResult(
              authenticated: false, 
              message: 'Такого пользователя нет в системе.',
              user: user,
            );
          }
        case Err(: final error):
          return AuthResult(
            authenticated: false, 
            message: 'Пользователь не найден, ошибка: $error',
            user: _user,
          );
      }
    })
    .catchError((e) {
      return AuthResult(
        authenticated: false, 
        message: 'Не удалось авторизоваться, \nОшибка: $e',
        user: _user,
      );
    });
  }
