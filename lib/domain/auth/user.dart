import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class User extends DataObject {
  bool isRequesting = false;
  User({
    required DataSet remote, 
  }) : super(remote: remote) {
    this['id'] = ValueString('');
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