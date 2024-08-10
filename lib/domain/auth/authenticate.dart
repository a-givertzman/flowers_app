// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
/// Auth user by phone number
class Authenticate {
  static const _debug = false;
  final _storeKey = 'spwd';
  // final FirebaseAuth _firebaseAuth;
  AppUser _user;
  Authenticate({
    required AppUser user,
    // required FirebaseAuth firebaseAuth,
  }) :
    _user = user;
    // _firebaseAuth = firebaseAuth;
  ///
  ///
  AppUser getUser() {
    return _user;
  }
  ///
  ///
  bool get isAuthenticated => _user.exists;
  ///
  ///
  Future<AuthResult> authenticateIfStored() async {
    final localStore = LocalStore();
    final phoneNumber = await localStore.readStringDecoded(_storeKey);
    if (phoneNumber != '') {
      return authenticateByPhoneNumber(phoneNumber);
    } else {
      return AuthResult(
        authenticated: false, 
        message: '',
        user: _user,
      );
    }
  }
  ///
  /// Номер должен состоять из 10 цифр без пробелов и других символов, например 9554443322
  Future<AuthResult> authenticateByPhoneNumber(String phoneNumber) {
    final userPhone = UserPhone(phone: phoneNumber);
    if (userPhone.validate().valid()) {
      return _user.fetch(userPhone).then((user) {
        log(_debug, '[Authenticate.authenticateByPhoneNumber] user: $user');
        return switch (user) {
          Ok(value : final user) => AuthResult(
              authenticated: true, 
              message: 'Авторизован успешно',
              user: user,
            ),
          Err(: final error) => AuthResult(
              authenticated: false, 
              message: 'Пользователя с номером $phoneNumber не найден. Ошибка: $error',
              user: _user,
            ),
        };
      })
      .catchError((e) {
        return AuthResult(
          authenticated: false, 
          message: 'Не удалось авторизоваться, \nОшибка: ${e.toString()}',
          user: _user,
        );
      });
    } else {
      return Future.value(AuthResult(
        authenticated: false, 
        message: 'Не корректный номером телефона пользователя: $phoneNumber, Номер должен состоять из 10 цифр без пробелов и других символов, например 9554443322',
        user: _user,
      ));
    }
  }
  ///
  ///
  Future<AuthResult> logout() async {
    final _localStore = LocalStore();
    await _localStore.remove(_storeKey);
    _user = _user.clear();
    // _firebaseAuth.signOut();
    return AuthResult(
      authenticated: false, 
      message: 'logged out', 
      user: _user,
    );
  }
}
