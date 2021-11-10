import 'package:flowers_app/domain/core/entities/value_object.dart';
import 'package:flowers_app/domain/core/entities/value_object_validation.dart';

class ValueString extends ValueObject {
  ValueString(
    value,
    {List<ValueValidation>? validationList}
  ){set(value);}
  @override
  String toString() {
    return get() ?? '';
  }
}