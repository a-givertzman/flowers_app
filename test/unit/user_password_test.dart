import 'package:flowers_app/domain/auth/user_password.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import './user_password_test.key' as user_pass;

void main() {
  test('User password length testing', () {
    const _length = 4;
    final _userPassword = UserPassword.generate(_length, _length);
    expect(_userPassword.value().length, equals(_length + _length + 1));
  });
  test('User password encryption based on rendom values', () {
    const _length = 4;
    for (var i = 0; i <= 1000; i++) {
      final _userPassword = UserPassword.generate(_length, _length);
      final _value = _userPassword.value();
      final _encrypted = _userPassword.encrypted();
      final _decrypted = UserPassword(value: _encrypted).decrypted();
      if (_value != _decrypted) {
        debugPrint("user password error: {v: '$_value', _encrypted: '$_encrypted'}");
      }
      expect(_value, equals(_decrypted));
    }
  });
  test('User password encryption based on key values', () {
    String _v = '';
    String _e = '';
    String _encrypted = '';
    String _decrypted = '';
    for (final _value in user_pass.values) {
      _v = _value['v'] ?? '';
      _e = _value['e'] ?? '';
      if (_v != '' && _e != '') {
        _encrypted = UserPassword(value: _v).encrypted();
        _decrypted = UserPassword(value: _e).decrypted();
        expect(_encrypted, equals(_e));
        expect(_decrypted, equals(_v));
      } else {
        debugPrint("user password error: {v: '$_value', e: '$_e'}");
        debugPrint("user password error: {_decrypted: '$_decrypted', _encrypted: '$_encrypted'}");
        expect(true, equals(false));
      }
    }
  });
  // NOTE we'll add more tests here later in this lesson
}
