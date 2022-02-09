import 'dart:convert';

import 'package:flowers_app/dev/log/log.dart';
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
  @override
  Notice.empty() :
    id = '',
    super.empty()
  {
    log('[Notice.empty] before init');
    this['id'] = ValueString('');
    this['purchase/id'] = ValueString('');
    this['purchase_content/id'] = ValueString('');
    this['message'] = ValueString('');
    this['created'] = ValueString('');
    this['updated'] = ValueString('');
    this['deleted'] = ValueString('');
    log('[Notice.empty] after init');
  }
  Future<bool> viewed() {
    final _id = '${this['id']}';
    final _groupId = '${this['purchase_content/id']}';
    if (_groupId == '') {
      return Future.value(true);
    }
    final _localStore = LocalStore();
    // _localStore.remove('$_storeKey$_groupId');   // для очисти _localStore
    return _localStore
      .readRawString('$_storeKey$_groupId')
      .then((_json) {
        try {
          final parsed = const JsonCodec().decode(_json) as List;
          log('[$Notice.viewed] parsed:', parsed);
          return parsed.contains(_id);
        } catch (error) {
          log('Ошибка в методе viewed класса $Notice:\n$error');
          return false;
        }
      });
  }
  Future<bool> setViewed() {
    final _id = '${this['id']}';
    if (_id == '') {
      return Future.value(false);
    }
    final _groupId = '${this['purchase_content/id']}';
    final _localStore = LocalStore();
    return _localStore
      .readRawString('$_storeKey$_groupId')
      .then((_json) {
        List<String> parsed = [];
        try {
          final _list = const JsonCodec().decode(_json) as List;
          parsed = _list.map((e) => '$e').toList();
        } catch (error) {
          log('Ошибка в методе setViewed класса $Notice:\n$error');
        }
          log('[$Notice.setViewed] parsed before:', parsed);
          if (!parsed.contains(_id)) {
            parsed.add(_id);
            log('[$Notice.setViewed] parsed after:', parsed);
            final encoded = const JsonCodec().encode(parsed);
            return _localStore.writeRawString('$_storeKey$_groupId', encoded);
          }
          return true;
      });
  }
  /// вернет true - если сообщение отправлено текущим пользователем
  bool isSent() {
    return false;
  }
}
