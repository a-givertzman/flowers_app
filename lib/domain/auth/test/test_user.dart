import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';

Future<void> main(List<String> args) async {
  // const _phone = '9818771070';
  const _phone = '9615258088';
  authenticateByPhoneNumber(_phone)
    .then((AuthResult authResult) {
      log('authResult: $authResult');
      log('authResult: ${authResult.authenticated()}');
      log('authResult: ${authResult.message()}');
    });
}
const _storeKey = 'spwd';
final _user = AppUser(
  remote: dataSource.dataSet('client'),
);
final _localStore = LocalStore();

  Future<AuthResult> authenticateByPhoneNumber(String phoneNumber) {

    return _user.fetch(params: {
      'phoneNumber': phoneNumber,
      // 'where': [{'operator': 'where', 'field': 'phone', 'cond': '=', 'value': phoneNumber}],
    },).then((user) {
      log('user: $user');
      if (user.valid() && '${user["name"]}' != '') {
        _localStore.writeString(_storeKey, phoneNumber);
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
    })
    .catchError((e) {
      return AuthResult(
        authenticated: false, 
        message: 'Не удалось авторизоваться, \nОшибка: ${e.toString()}',
        user: _user,
      );
    });
  }
