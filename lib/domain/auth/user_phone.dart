import 'package:flowers_app/domain/core/entities/validation_result.dart';

class UserPhone {
  final String _phone;
  UserPhone({
    required phone,
  }) : _phone = phone;
  ValidationResult validate() {
    String pattern = r'/^[0-9]{10}$/';
    RegExp regex = RegExp(pattern);
    final _valid = regex.hasMatch(_phone);
    return ValidationResult(
      valid: _valid,
      message: _valid ? '' : 'Номер должен состоять из 10 цифр без пробелов и других символов, например 9554443322',
    );
  }
  String value() {
    return _phone;
  }
}
