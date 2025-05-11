import 'package:flower_app/domain/core/entities/value_object.dart';
import 'package:flower_app/domain/core/entities/value_object_validation.dart';

class ValueString extends ValueObject<String> {
  final List<ValueValidation>? _validationList;
  ValueString(
    super.value,
    {List<ValueValidation>? validationList,}
  ):
    _validationList = validationList;
  @override
  String toString() {
    return get();
  }
  String valid() {
    final vList = _validationList;
    if (vList == null) {
      return '';
    }
    return vList.map(
      (validation) => validation.validate(get()),
    ).join('; ') ;
  }
  @override
  ValueObject<String> toDomain(String value) {
    return ValueString(value);
  }
}
