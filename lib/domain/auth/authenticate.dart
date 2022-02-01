// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';

class Authenticate {
  final _storeKey = 'spwd';
  // final FirebaseAuth _firebaseAuth;
  AppUser _user;
  Authenticate({
    required AppUser user,
    // required FirebaseAuth firebaseAuth,
  }) :
    _user = user;
    // _firebaseAuth = firebaseAuth;
  AppUser getUser() {
    return _user;
  }
  bool authenticated() {
    return _user.exists();
  }
  Future<AuthResult> authenticateIfStored() async {
    final _localStore = LocalStore();
    final phoneNumber = await _localStore.readString(_storeKey);
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
  Future<AuthResult> authenticateByPhoneNumber(String phoneNumber) {
    return _user.fetch(params: {
      'phoneNumber': phoneNumber,
    },).then((user) {
      log('[Authenticate.authenticateByPhoneNumber] user: $user');
      if (user.exists()) {
        final _localStore = LocalStore();
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
    final _localStore = LocalStore();
    await _localStore.remove(_storeKey);
    _user = _user.empty();
    // _firebaseAuth.signOut();
    return AuthResult(
      authenticated: false, 
      message: 'logged out', 
      user: _user,
    );
  }
}
