import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Ксласс хранит в себе информацию сообщении
class Notice extends DataObject{
  final _storeKey = 'lastViewedNoticeId';
  final String id;
  Notice({
    required this.id, 
    required DataSet<Map>  remote,
  }) : super(remote: remote) {    
    this['id'] = ValueString('');
    this['purchase/id'] = ValueString('');
    this['purchase_content/id'] = ValueString('');
    this['message'] = ValueString('');
    this['created'] = ValueString('');
    this['updated'] = ValueString('');
    this['deleted'] = ValueString('');
  }
  Future<bool> viewed() async {
    final _localStore = LocalStore();
    final lastViewedNoticeIdStr = await _localStore.readString(_storeKey);
    final lastViewedNoticeId = int.tryParse(lastViewedNoticeIdStr);
    if (lastViewedNoticeId == null) {
      return false;
    }
    return lastViewedNoticeId >= int.parse(id);
  }
}
