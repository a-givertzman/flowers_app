import 'package:flower_app/domain/core/entities/value_object.dart';
import 'package:flower_app/domain/core/entities/value_object_validation.dart';

class ValueMultyLineString extends ValueObject<String> {
  final List<ValueValidation>? _validationList;
  ValueMultyLineString(
    super.value,
    {List<ValueValidation>? validationList,}
  ):
    _validationList = validationList;
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
    final vList = _validationList;
    if (vList == null) {
      return '';
    }
    return vList.map(
      (validation) => validation.validate(get()),
    ).join('; ') ;
  }
}
