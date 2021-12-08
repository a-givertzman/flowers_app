import 'package:flowers_app/domain/core/entities/validation_result.dart';

/// Класс хранит номер телефона в 10-ти значном формате
/// и код страны в строке как пример +7
/// метод validate() возвращает положительный ValidationResult 
/// если длина номера 10 цифр, если в номере нет ничего кроме цифр
class UserPhone {
  final String _countryCode;
  final String _phone;
  UserPhone({
    /// код страны, по умолчанию +7
    String? code,
    required String phone,
  }) :
    _countryCode = code ?? '+7',
    _phone = phone;
  ValidationResult validate() {
    final regex = RegExp(r"^[0-9]{10}$");
    final _valid = regex.hasMatch(_phone);
    return ValidationResult(
      valid: _valid,
      message: _valid ? null : 'Номер должен состоять из 10 цифр без пробелов и других символов, например 9554443322',
    );
  }
  // возвращает 10 цифр номера без сода страны
  String value() => _phone;
  // возвращает код страны в формате +7
  String code() => _countryCode;
  // возвращает номер телефона с кодом страны +75553332211
  String phoneWithCode() => '$_countryCode$_phone';
}
