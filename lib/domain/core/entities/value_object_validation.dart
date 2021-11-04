import 'package:flowers_app/domain/core/entities/value_object.dart';

abstract class ValueValidation<T> {
  final String message;
  const ValueValidation({
    required this.message,
  });
  String validate(T value) {
    return message;
  }
}