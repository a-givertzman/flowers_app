import 'package:flowers_app/domain/core/entities/value_object.dart';
import 'package:flowers_app/domain/core/entities/value_object_validation.dart';

class ValueString extends ValueObject<String> {
  final List<ValueValidation>? _validationList;
  ValueString(
    String value,
    {List<ValueValidation>? validationList,}
  ):
    _validationList = validationList,
    super(value);
  @override
  String toString() {
    return get();
  }
  String valid() {
    final _vList = _validationList;
    if (_vList == null) {
      return '';
    }
    return _vList.map(
      (_validation) => _validation.validate(get()),
    ).join('; ') ;
  }
}
