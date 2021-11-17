import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_multy_line_string.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class User extends DataObject {
  // final _streamController = StreamController<List<dynamic>>();
  // late DataSource _dataSource;
  // late DataSet _dataSet;
  // Stream<List<dynamic>> get authStream {
  //   _streamController.onListen = _dispatch;
  //   return  _streamController.stream;
  // }
  bool isRequesting = false;
  final String id;
  User({
    required this.id,
    required DataSet remote, 
  }) : super(remote: remote) {
    this['group'] = ValueString('');
    this['location'] = ValueString('');
    this['name'] = ValueString('');
    this['phone'] = ValueString('');
    this['account'] = ValueString('');
  }
  // void _dispatch() async {
  //   print('[PurchaseList._dispatch]');
  //   //TODO Implement _dispatch method of User class
  // }
}