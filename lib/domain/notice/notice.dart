import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
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
  Notice.empty() :
    id = '0',
    super(
      remote: DataSet(
        apiRequest: const ApiRequest(url: ''), 
        params: ApiParams({}),
      ),
  ) {
    this['id'] = ValueString('');
    this['purchase/id'] = ValueString('');
    this['purchase_content/id'] = ValueString('');
    this['message'] = ValueString('');
    this['created'] = ValueString('');
    this['updated'] = ValueString('');
    this['deleted'] = ValueString('');
  }
  Future<bool> viewed() async {
    final _id = '${this['id']}';
    final _groupId = '${this['purchase_content/id']}';
    if (_groupId == null || _groupId == '') {
      return true;
    }
    final _localStore = LocalStore();
    final lastViewedNoticeIdStr = await _localStore.readString('$_storeKey$_groupId');
    final lastViewedNoticeId = int.tryParse(lastViewedNoticeIdStr);
    if (lastViewedNoticeId == null) {
      return false;
    }
    return lastViewedNoticeId >= int.parse(id);
  }
  Future<bool> setViewed() async {
    final _id = '${this['id']}';
    final _groupId = '${this['purchase_content/id']}';
    final _localStore = LocalStore();
    final lastViewedNoticeIdStored = await _localStore.writeString('$_storeKey$_groupId', _id);
    return lastViewedNoticeIdStored;
  }
}
