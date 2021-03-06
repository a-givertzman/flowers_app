import 'package:flowers_app/domain/core/entities/value_object.dart';
import 'package:flowers_app/domain/core/entities/value_object_validation.dart';

class ValueMultyLineString extends ValueObject<String> {
  final List<ValueValidation>? _validationList;
  ValueMultyLineString(
    String value,
    {List<ValueValidation>? validationList,}
  ):
    _validationList = validationList, 
    super(value);
  @override
  ValueMultyLineString toDomain(String value) {
    return ValueMultyLineString(
      value.isNotEmpty
        ? value
          .replaceAll(RegExp("^"), ' - ')
          .replaceAll(RegExp(r"(<\*>)"), '\n - ')
        : '',
    );
  }
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
