import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class User extends DataObject {
  final DataSet _remote;
  User({
    required DataSet remote, 
  }) :
    _remote = remote,
    super(remote: remote) {
    _init();
  }
  User.register({
    required String group,
    required String location,
    required String name,
    required String phone,
    required DataSet remote,
  }): 
    _remote = remote, 
    super(remote: remote) {
    _init();
    this['group'] = ValueString(group);
    this['location'] = ValueString(location);
    this['name'] = ValueString(name);
    this['phone'] = ValueString(phone);
    // return User(remote: _remote);
  }
  User empty() {
    return User(remote: _remote);
  }
  void _init() {
    this['id'] = ValueString('');
    this['group'] = ValueString('');
    this['location'] = ValueString('');
    this['name'] = ValueString('');
    this['phone'] = ValueString('');
    this['account'] = ValueString('');
    this['created'] = ValueString('');
    this['updated'] = ValueString('');
    this['deleted'] = ValueString('');
  }
  // void _dispatch() async {
  //   print('[PurchaseList._dispatch]');
  //   //TODO Implement _dispatch method of User class
  // }
}