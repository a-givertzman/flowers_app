import 'dart:convert';
import 'user_password.key' as user_pass;

class UserPassword {
  final _key = user_pass.key;
  final String _value;
  UserPassword({
    required String value,
  }):
    _value = value;
  String encrypted() {
    return _encrypt(_value, _key);
  }
  String decrypted() {
    return _decrypt(_value, _key);
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
