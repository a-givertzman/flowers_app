import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_multy_line_string.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class Purchase extends DataObject{
  // bool _valid = true;
  final String id;

  Purchase({
    required this.id, 
    required DataSet<Map>  remote,
  }) : super(remote: remote) {
    this['id'] = ValueString('');
    // this['status'] = ValueString('');
    this['name'] = ValueString('');
    this['details'] = ValueString('');
    this['preview'] = ValueMultyLineString('');
    this['description'] = ValueString('');
    // this['date_of_start'] = ValueString('');
    // this['date_of_end'] = ValueString('');
    this['created'] = ValueString('');
    this['updated'] = ValueString('');
    this['deleted'] = ValueString('');
  }
  // bool valid() {
  //   //TODO Purchase valid method to be implemented
  //   return _valid;
  // }
}
