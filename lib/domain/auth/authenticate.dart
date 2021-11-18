import 'package:flowers_app/domain/auth/user.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/core/entities/validation_result.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';

class Authenticate {
  final _storeKey = 'spwd';
  final LocalStore _localStore;
  final User _user;
  Authenticate({
    required localStore,
    required user
  }) :
    _localStore = localStore,
    _user = user;
  ValidationResult validatePhone(String phoneNumber) {
    return UserPhone(phone: phoneNumber).validate();
  }
  User getUser() {
    return _user;
  }
  bool authenticated() {
    return ('${_user["name"]}' != '');
  }
  Future<AuthResult> authenticateIfStored() async {
    final phoneNumber = await _localStore.readString(_storeKey);
    if (phoneNumber != '') {
      return await authenticateByPhoneNumber(phoneNumber);
    } else {
      return AuthResult(
        authenticated: false, 
        message: '',
        user: _user,
      );
    }
  }
  Future<AuthResult> authenticateByPhoneNumber(String phoneNumber) {
    return _user.fetch(params: {
      'where': [{'operator': 'where', 'field': 'phone', 'cond': '=', 'value': phoneNumber}],
    }).then((user) {
      print('user: $user');
      print("user id: `${user['id']}`");
      print("user name: `${user['name']}`");
      print("user account: `${user['account']}`");
      if ('${user["name"]}' != '') {
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
  Future<AuthResult> logout() async {
    await _localStore.remove(_storeKey);
    return AuthResult(
      authenticated: false, 
      message: 'logged out', 
      user: _user
    );
  }
}