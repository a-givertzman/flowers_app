import 'package:flowers_app/domain/core/entities/value_object.dart';
import 'package:flowers_app/domain/core/entities/value_object_validation.dart';

class ValueMultyLineString extends ValueObject {
  ValueMultyLineString(
    value,
    {List<ValueValidation>? validationList}
  ) {set(value);}
  @override
  toDomain(dynamic value) {
    set(
      (value != null)
          ? value.toString()
            .replaceAll(RegExp(r"^"), ' - ')
            .replaceAll(RegExp(r"(<\*>)"), '\n - ')
          : ''
    );
    return get();
  }
  @override
  String toString() {
    return get();
  }
}