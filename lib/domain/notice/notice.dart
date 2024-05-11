import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Ксласс хранит в себе информацию сообщении
class Notice extends DataObject{
  final Future<bool> _viewed;
  Notice({
    required DataSet<Map> remote,
    required Future<bool> viewed,
  }) : 
    _viewed = viewed,
    super(remote: remote)
  {
    init();
  }
  @override
  Notice.empty() :
    _viewed = Future.value(true),
    super.empty()
  {
    init();
  }
  void init() {
    this['id'] = ValueString('');
    this['purchase/id'] = ValueString('');
    this['purchase_content/id'] = ValueString('');
    this['message'] = ValueString('');
    this['created'] = ValueString('');
    this['updated'] = ValueString('');
    this['deleted'] = ValueString('');
  }
  Future<bool> viewed() => _viewed;
  /// вернет true - если сообщение отправлено текущим пользователем
  bool isSent() {
    return false;
  }
}
