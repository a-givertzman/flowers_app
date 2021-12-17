import 'dart:convert';
import 'dart:math';
import 'package:flowers_app/domain/core/entities/validation_result.dart';

import 'user_password.key' as user_pass;

class UserPassword {
  final _key = user_pass.key;
  final minLength = 5;
  final maxLength = 30;
  final String _value;
  UserPassword({
    required String value,
  }):
    _value = value;
  factory UserPassword.generate() {
    final part1 = _generateRandomString(4);
    final part2 = _generateRandomString(4);
    return UserPassword(value: '$part1-$part2');
  }
  String value() => _value;
  String encrypted() {
    return _encrypt(_value, _key);
  }
  String decrypted() {
    return _decrypt(_value, _key);
  }
  ValidationResult validate() {
    final regex = RegExp('^.{$minLength,$maxLength}\$');
    final _valid = regex.hasMatch(_value);
    return ValidationResult(
      valid: _valid,
      message: _valid ? null : 'Символов не менее: $minLength',
    );
  }
  String _encrypt(String source, String key) {
    final sourceCodes = Uri.encodeComponent(source).codeUnits;
    final keyCodes = Uri.encodeComponent(key).codeUnits;
    final sourceLength = sourceCodes.length;
    final keyLength = keyCodes.length;
    Iterable<int> innerEncrypt() sync* {
      for (var i = 0; i < sourceLength; i++) {
        yield sourceCodes[i] ^ keyCodes[i % keyLength];
      }
    }

    return base64Url.encode(
      innerEncrypt().toList(growable: false),
    );
  }
  String _decrypt(String source, String key) {
    final sourceCodes = base64Decode(source);
    final keyCodes = Uri.encodeComponent(key).codeUnits;
    final sourceLength = sourceCodes.length;
    final keyLength = keyCodes.length;
    Iterable<int> innerDecrypt() sync* {
      for (var i = 0; i < sourceLength; i++) {
        yield sourceCodes[i] ^ keyCodes[i % keyLength];
      }
    }

    return Uri.decodeComponent(
      String.fromCharCodes(
        innerDecrypt().toList(growable: false),
      ),
    );
  }
}

String _generateRandomString(int len) {
  const _chars = '!%&AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!%&';
  final r = Random.secure();
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
