import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_multy_line_string.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';

class Purchase extends DataObject{
  // bool _valid = true;
  final String id;

  Purchase({
    required this.id, 
    required remote,
  }) : super(remote: remote) {
    this['name'] = ValueString('');
    this['details'] = ValueString('');
    this['preview'] = ValueMultyLineString('');
    this['description'] = ValueString('');
  }
  // bool valid() {
  //   //TODO Purchase valid method to be implemented
  //   return _valid;
  // }
}
