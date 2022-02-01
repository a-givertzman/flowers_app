import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class AppUser extends DataObject {
  final DataSet<Map> _remote;
  AppUser({
    required DataSet<Map> remote, 
  }) :
    _remote = remote,
    super(remote: remote) {
    _init();
  }
  AppUser empty() {
    return AppUser(remote: _remote);
  }
  void _init() {
    this['id'] = ValueString('');
    this['group'] = ValueString('');
    this['location'] = ValueString('');
    this['name'] = ValueString('');
    this['phone'] = ValueString('');
    this['pass'] = ValueString('');
    this['account'] = ValueString('');
    this['created'] = ValueString('');
    this['updated'] = ValueString('');
    this['deleted'] = ValueString('');
  }
  @override
  String toString() {
    var str = '';
    asMap().forEach((key, value) {
      str += '$key: $value; ';
    });
    return str;
  }
  /// Возвращает true после загруз пользователя из базы
  /// если пользователь в базе есть, false если его там нет
  /// Возвращает null если еще не загружен
  bool exists() {
    if (!valid()) {
      return false;
    }
    if (valid() && '${this["id"]}' != '' && '${this["phone"]}' != '') {
      return true;
    } else {
      return false;
    }
  }
  @override
  Future<AppUser> fetch({Map<String, dynamic> params = const {}}) {
    // TODO: implement fetch
    return super
      .fetch(params: params)
      .then((value) {
        return value as AppUser;
      });
  }
}
