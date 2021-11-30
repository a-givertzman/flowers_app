import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class User extends DataObject {
  bool isRequesting = false;
  final DataSet _remote;
  User({
    required DataSet remote, 
  }) :
    _remote = remote,
    super(remote: remote) {
    this['id'] = ValueString('');
    this['group'] = ValueString('');
    this['location'] = ValueString('');
    this['name'] = ValueString('');
    this['phone'] = ValueString('');
    this['account'] = ValueString('');
  }
  User clear() {
    return User(remote: _remote);
  }
  // void _dispatch() async {
  //   print('[PurchaseList._dispatch]');
  //   //TODO Implement _dispatch method of User class
  // }
}