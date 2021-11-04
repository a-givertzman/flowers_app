import 'package:flowers_app/domain/core/entities/value_object_validation.dart';
import 'package:flutter/foundation.dart';


@immutable
abstract class ValueObject<T> {
  final List<ValueValidation> validationList;
  const ValueObject({
    required this.validationList,
  });
  
  T get value;

  String? validator(T) {
    String message = '';
    for (var validation in validationList) {
      message += '\n' + validation.validate(value);
    }
    return message.isEmpty ? null : message;
  }

  @override
  bool operator == (Object o) {
    if (identical(this, o)) return true;

    return (o is ValueObject<T>) && (o.value == value);
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'Value($value)';
  }
}
